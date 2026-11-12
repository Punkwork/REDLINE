extends RefCounted
class_name RedlineRules

# Independent deterministic rule helpers; integration with phase engine pending.
# SyN is chosen discard, NOT random discard.
static func resolve_pulp(state: Dictionary, amount: int) -> void:
    var prevented: int = min(max(0, amount), int(state.get("pulp_prevention", 0)))
    state["pulp_prevention"] = int(state.get("pulp_prevention", 0)) - prevented
    var dealt: int = max(0, amount - prevented)
    state["vitae"] = max(0, int(state.get("vitae", 0)) - dealt)
    state["log"].append("PULP %d (prevented %d)" % [amount, prevented])

static func resolve_syn(state: Dictionary, amount: int, hand_indices: Array[int]) -> bool:
    # Selection must be valid and cover as much SyN as the available hand permits.
    var required: int = min(max(0, amount), state["hand"].size())
    if hand_indices.size() != required:
        return false
    var unique := {}
    for index in hand_indices:
        if index < 0 or index >= state["hand"].size() or unique.has(index):
            return false
        unique[index] = true
    hand_indices.sort()
    hand_indices.reverse()
    for index in hand_indices:
        state["discard"].append(state["hand"].pop_at(index))
    var unmet: int = max(0, amount - required)
    state["vitae"] = max(0, int(state.get("vitae", 0)) - unmet * 2)
    state["log"].append("SyN %d: discarded %d, Vitae lost %d" % [amount, required, unmet * 2])
    return true

static func trace_succeeds(trace_value: int, resistance: int) -> bool:
    return trace_value > resistance

static func can_spend(state: Dictionary, bw: int, ram: int) -> bool:
    return int(state.get("bw", 0)) >= bw and int(state.get("ram_free", 0)) >= ram

static func spend(state: Dictionary, bw: int, ram: int) -> bool:
    if not can_spend(state, bw, ram):
        return false
    state["bw"] = int(state["bw"]) - bw
    state["ram_free"] = int(state["ram_free"]) - ram
    return true

static func extract(state: Dictionary, amount: int) -> int:
    var paid: int = min(max(0, amount), int(state.get("cred_remaining", 0)))
    state["cred_remaining"] = int(state.get("cred_remaining", 0)) - paid
    state["cred"] = int(state.get("cred", 0)) + paid
    if int(state["cred_remaining"]) == 0 and not state.get("full_extraction_awarded", false):
        state["full_extraction_awarded"] = true
        var bonus: int = int(ceil(float(state.get("original_cred_reserve", 0)) * 0.1))
        state["cred"] = int(state["cred"]) + bonus
        state["log"].append("Full extraction bonus +%d CRED" % bonus)
    return paid
