from typing import Set


def insert_in_set(set: Set[str], value: str) -> bool:
    previous_len = len(set)
    set.add(value)
    if (len(set) > previous_len):
        return True
    else:
        return False
