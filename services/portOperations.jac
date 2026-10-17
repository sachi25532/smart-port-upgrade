node PortState {
    has minute: int = 0,
        vessel_x: int = 18,
        crane_failed: bool = False,
        cargo_progress: int = 40,
        plan_ready: bool = False,
        plan_approved: bool = False,
        berth: str = "Berth 01";
}

def _state() -> PortState {
    states = [root -->][?:PortState];
    if len(states) > 0 { return states[0]; }
    fresh = root ++> PortState();
    return fresh as PortState;
}

def:pub getPortSnapshot() -> dict {
    state = _state();
    return {"minute": state.minute, "vessel_x": state.vessel_x, "crane_failed": state.crane_failed, "cargo_progress": state.cargo_progress, "plan_ready": state.plan_ready, "plan_approved": state.plan_approved, "berth": state.berth};
}

def:pub resetSimulation() -> dict {
    state = _state();
    state.minute = 0;
    state.vessel_x = 18;
    state.crane_failed = False;
    state.cargo_progress = 40;
    state.plan_ready = False;
    state.plan_approved = False;
    state.berth = "Berth 01";
    return getPortSnapshot();
}

def:pub advanceSimulation(step: int) -> dict {
    bounded_step = step;
    if bounded_step < 1 { bounded_step = 1; }
    if bounded_step > 60 { bounded_step = 60; }
    state = _state();
    state.minute += bounded_step;
    state.vessel_x += bounded_step;
    if state.vessel_x > 90 { state.vessel_x = 10; state.berth = "Berth 02"; }
    cargo_rate = 2 if not state.crane_failed else 0;
    state.cargo_progress += bounded_step * cargo_rate;
    if state.cargo_progress > 100 { state.cargo_progress = 100; }
    return getPortSnapshot();
}

def:pub injectCraneFailure() -> dict {
    state = _state();
    state.crane_failed = True;
    state.plan_ready = False;
    state.plan_approved = False;
    return getPortSnapshot();
}

def:pub restoreCrane() -> dict {
    state = _state();
    state.crane_failed = False;
    return getPortSnapshot();
}

def:pub runBerthReplanner() -> dict {
    state = _state();
    state.plan_ready = True;
    state.plan_approved = False;
    if state.crane_failed { state.berth = "Berth 02 (proposed)"; }
    return getPortSnapshot();
}

def:pub approveSchedule() -> dict {
    state = _state();
    if state.plan_ready { state.plan_approved = True; }
    return getPortSnapshot();
}
