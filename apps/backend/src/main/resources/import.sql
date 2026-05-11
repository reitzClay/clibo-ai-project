-- Goals
INSERT INTO Goal (id, title, pillar, targetValue, achieved) 
VALUES (nextval('Goal_SEQ'), 'Reach Physical Speed 9/10', 'PHYSICAL', 9, false);

-- Users
INSERT INTO clibo_users (id, username, email, subscriptionStatus, tenantId) 
VALUES (nextval('clibo_users_SEQ'), 'clayt', 'clay@example.com', 'ACTIVE', 'default');

-- Seeds (Initial AI knowledge)
INSERT INTO clibo_seeds (id, branch, leaf, pillar, impactValue, is_ai_generated, created_at)
VALUES (nextval('clibo_seeds_SEQ'), 'Morning Routine', 'Drink 500ml water immediately', 'PHYSICAL', 5, true, CURRENT_TIMESTAMP);

-- User AI Configuration
INSERT INTO UserConfig (id, user_id, providerType, modelName, baseUrl, isActive) 
VALUES (nextval('UserConfig_SEQ'), currval('clibo_users_SEQ'), 'OLLAMA', 'llama3.2:3b', 'http://localhost:11434', true);

-- TemporalBlocks (Timeline/Calendar)
INSERT INTO TemporalBlock (id, title, pillar, blockType, startTime, endTime, priority, isCompleted, location)
VALUES (nextval('TemporalBlock_SEQ'), 'High Intensity Sprint', 'PHYSICAL', 'WORKOUT', '2026-05-11 11:00:00', '2026-05-11 12:00:00', 1, false, 'Local Gym');

INSERT INTO TemporalBlock (id, title, pillar, blockType, startTime, endTime, priority, isCompleted, location)
VALUES (nextval('TemporalBlock_SEQ'), 'Deep Work: AI Integration', 'INTELLECTUAL', 'WORK', '2026-05-11 13:00:00', '2026-05-11 13:45:00', 2, false, 'Home Office');

INSERT INTO TemporalBlock (id, title, pillar, blockType, startTime, endTime, priority, isCompleted, location)
VALUES (nextval('TemporalBlock_SEQ'), 'Mindfulness Session', 'EMOTIONAL', 'REST', '2026-05-11 15:00:00', '2026-05-11 15:30:00', 3, true, 'Garden');
