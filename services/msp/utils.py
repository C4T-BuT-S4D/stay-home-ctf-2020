import math
import datetime
import uuid
from universe import Universe


def normalize_height(a):

    return max(Universe.DROP_ORBIT_H_MIN, min(Universe.DROP_ORBIT_H_MAX, a))


def now():
    return datetime.datetime.now(datetime.timezone.utc)
