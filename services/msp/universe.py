import datetime


class Universe:
    MU = 50e8
    ANT_MAX_ANGLE = 0.5
    DROP_ORBIT_H_MIN = 5000
    DROP_ORBIT_H_MID = 1e8
    DROP_ORBIT_H_MAX = 9e8
    MAX_DT = datetime.timedelta(seconds=5)
    LAG_TPS = 5
    GOOD_TPS = 30
    MASS_TO_SPEED = 0.1
