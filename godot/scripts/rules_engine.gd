extends RefCounted
class_name RedlineRules

# Deterministic state transitions. The encounter manifest is deliberately
# external so no unverified playtest values enter the rules engine.
static func resolve_pulp(state: Dictionary, amount: int) -> void:
    state.integrity = max(0, int(state.integrity) - max(0, amount))
    state.log.append("PULP %d" % amount)

static func resolve_syn(state: Dictionary, amount: int, rng: RandomNumberGenerator) -> void:
    for i in range(min(max(0, amount), state.hand.size())):
        var index := rng.randi_range(0, state.hand.size() - 1)
        state.discard.append(state.hand.pop_at(index))
    state.log.append("SYN %d" % amount)

static func resolve_neural(state: Dictionary, hand_indices: Array[int]) -> void:
    hand_indices.sort()
    hand_indices.reverse()
    for index in hand_indices:
        if index >= 0 and index < state.hand.size():
            state.discard.append(state.hand.pop_at(index))
    state.log.append("NEURAL %d" % hand_indices.size())

static func trace_succeeds(trace_value: int, resistance: int) -> bool:
    return trace_value > resistance

static func can_spend(state: Dictionary, bw: int, ram: int) -> bool:
    return int(state.bw) >= bw and int(state.ram_free) >= ram

static func spend(state: Dictionary, bw: int, ram: int) -> bool:
    if not can_spend(state, bw, ram):
        return false
    state.bw -= bw
    state.ram_free -= ram
    return true
