import React, { useState } from 'react';
import './configurations.css';

// Configurations component with switch for showing deterministic or relativistic sections
function Configurations({ children }) {
    const [showDeterministic, setShowDeterministic] = useState(true);

    const toggleConfiguration = () => {
        setShowDeterministic(!showDeterministic);
    };

    return (
        <div>
            <div className="switch-container">
                <div className="spacer">Use physics</div>
                <label className="switch">
                    <input type="checkbox" checked={!showDeterministic} onChange={toggleConfiguration}/>
                    <span className="slider round"></span>
                </label>
            </div>
            <div className="spacer"></div>
            {/* Children is used to render the markdown content */}
            {showDeterministic ? children[0] : children[1]}
        </div>
    );
}

export default Configurations;