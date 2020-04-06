import math
import logging
from asyncpg.pgproto.types import Point
from universe import Universe
from utils import now
from utils import normalize_height
import uuid


def object_from_row(row):
    return Object(
        idx=row['id'],
        position=row['position'],
        velocity=row['velocity'],
        mass=row['mass'],
        refreshed_at=row['refreshed_at'],
        narrow_beam_response=row['narrow_beam_response'],
        antenna=row['antenna'],
    )


def object_from_config(cfg):

    phase = math.radians(cfg['phase'])
    Ph = normalize_height(cfg.get('height', 0))
    pos = Point(Ph * math.sin(phase), Ph * math.cos(phase))
    speed = math.sqrt(Universe.MU / Ph)
    vel = Point(
        speed * math.sin(phase + math.pi / 2),
        speed * math.cos(phase + math.pi / 2),
    )

    ant_a = Universe.DROP_ORBIT_H_MAX * 2
    if Ph >= Universe.DROP_ORBIT_H_MID:
        ant_a = 0
        ant_b = 0
    else:
        ant_angl = min(Universe.ANT_MAX_ANGLE,
                       math.radians(cfg['antenna_focus']))
        ant_b = ant_a * math.sin(ant_angl)

    obj = Object(
        idx=str(uuid.uuid4()),
        position=pos,
        velocity=vel,
        mass=cfg['mass'],
        refreshed_at=now(),
        narrow_beam_response=cfg['narrow_beam_response'],
        antenna=Point(ant_a, ant_b),
    )

    return obj


class Object():
    def __init__(self, idx, position, velocity, mass, refreshed_at,
                 narrow_beam_response, antenna):

        self.idx = idx
        self.position = position
        self.velocity = velocity
        self.mass = mass
        self.narrow_beam_response = narrow_beam_response
        self.antenna = antenna
        self.refreshed_at = refreshed_at
        self.logger = logging.getLogger('object::' + str(idx))

    def debug(self):

        self.logger.debug('Object data', self.encode())

    def encode(self):
        return dict(
            idx=str(self.idx),
            position=self.position,
            velocity=self.velocity,
            mass=self.mass,
            dist=self.distance_to_sun(),
            acc=self.acceleration(),
            angle=self.angle(),
            refreshed_at=self.refreshed_at.isoformat(),
            antenna_a=self.antenna[0],
            antenna_b=self.antenna[1],
        )

    def angle(self):

        return math.atan2(self.position[1], self.position[0])

    def distance_to_sun(self):

        return math.hypot(self.position[0], self.position[1])

    def acceleration(self):

        dist = self.distance_to_sun()

        force = -Universe.MU / (dist * dist)

        angle = self.angle()

        return Point(
            force * math.cos(angle),
            force * math.sin(angle),
        )

    def update(self, tc):

        T = now()
        dt = (T - self.refreshed_at).total_seconds()

        maxdt = Universe.MAX_DT
        if dt > maxdt.total_seconds():
            dt = maxdt.total_seconds()
            T = self.refreshed_at + maxdt

        acc = self.acceleration()

        # update velocity
        self.velocity = Point(
            self.velocity[0] + acc[0] * dt,
            self.velocity[1] + acc[1] * dt,
        )

        # thrust processing
        if tc is not None:

            angle = tc.get('angle')
            duration = tc.get('duration')

            self.logger.debug(
                f'thrust command on {self.idx}: {angle}:{duration}')

            if duration > self.mass:
                self.logger.debug(f'flame-out on {self.idx}')
                duration = 0

            burn = duration * Universe.MASS_TO_SPEED * 100

            self.logger.debug(f'burn size: {burn}')

            self.velocity = Point(
                self.velocity[0] + math.sin(angle) * burn,
                self.velocity[1] + math.cos(angle) * burn,
            )

            self.mass -= duration
            self.logger.debug(f'new mass: {self.mass}')

        # update position
        self.position = Point(
            self.position[0] + self.velocity[0] * dt,
            self.position[1] + self.velocity[1] * dt,
        )

        # update refreshed_at
        self.refreshed_at = T
