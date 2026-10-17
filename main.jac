import from services.portOperations { getPortSnapshot, resetSimulation, advanceSimulation, injectCraneFailure, restoreCrane, runBerthReplanner, approveSchedule }
import from .components.PortMindDashboard { PortMindDashboard }
import ".styles.global.css";

def:pub app() -> JsxElement {
    return <PortMindDashboard />;
}
