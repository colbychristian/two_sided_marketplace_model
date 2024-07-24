% MATLAB Implementation of a Two-Sided Market Model
% This script models the dynamics of a two-sided market with consumers and developers.

% --- INPUT SECTION ---
% Answer the following questions to set the parameters of the model.

% Consumer Attrition Rate
% Q: What percentage of your customers leave the platform each month?
% Example: 5 for 5%
consumerAttritionRate = 0.5; % User input: replace with the attrition rate percentage

% Consumer Growth Rate
% Q: What percentage growth in new customers do you experience monthly?
% Example: 10 for 10%
consumerGrowthRate = 5; % User input: replace with the growth rate percentage

% Developer Attrition Rate
% Q: What percentage of your vendors or developers leave the platform each month?
% Example: 3 for 3%
developerAttritionRate = 1; % User input: replace with the attrition rate percentage

% Developer Growth Rate
% Q: What percentage growth in new vendors or developers do you experience monthly?
% Example: 7 for 7%
developerGrowthRate = 10; % User input: replace with the growth rate percentage

% Consumer Affinity
% Q: How attractive do you believe your platform is to new consumers when the platform is fully developed?
% (1 = Not Attractive, 10 = Very Attractive)
consumerAffinity = 9; % User input: replace with a number from 1 to 10

% Developer Affinity
% Q: How attractive do you believe your platform is to developers when there is a large consumer base?
% (1 = Not Attractive, 10 = Very Attractive)
developerAffinity = 10; % User input: replace with a number from 1 to 10

% Consumer Growth Sensitivity
% Q: How sensitive are consumers to changes in the number of available products or services?
% (1 = Not Sensitive, 5 = Highly Sensitive)
consumerGrowthSensitivity = 2; % User input: replace with a number from 1 to 5

% Developer Growth Sensitivity
% Q: How sensitive are developers to changes in the consumer base size?
% (1 = Not Sensitive, 5 = Highly Sensitive)
developerGrowthSensitivity = 3; % User input: replace with a number from 1 to 5

% Consumer Market Saturation
% Q: At what size do you expect the attractiveness to new consumers to stop increasing significantly?
% (1 = Few Products, 5 = Many Products)
consumerSaturation = 4; % User input: replace with a number from 1 to 5

% Developer Market Saturation
% Q: At what size do you expect the attractiveness to new developers to stop increasing significantly?
% (1 = Few Consumers, 5 = Many Consumers)
developerSaturation = 5; % User input: replace with a number from 1 to 5

% Initial Number of Consumers
% Q: How many consumers are currently using your platform?
initialConsumers = 200; % User input: replace with the actual number of current consumers

% Initial Number of Developers
% Q: How many developers or vendors are currently providing products or services on your platform?
initialDevelopers = 30; % User input: replace with the actual number of current developers

% Simulation Time
% Q: How long do you want the simulation to run (in days)?
days = 200;

% --- PARAMETER SETTING BASED ON INPUT ---

% Rate Parameters (as decimals)
epsilon1 = consumerAttritionRate / 100; % Consumer Death Rate
epsilon2 = consumerGrowthRate / 100; % Consumer Birth Rate
epsilon3 = developerAttritionRate / 100; % Developer Death Rate
epsilon4 = developerGrowthRate / 100; % Developer Birth Rate

% Affinity Curve Parameters
gu_max_values = [0, 200, 300, 400, 500, 600, 700, 800, 900, 1000];
gm_max_values = [0, 200, 300, 400, 500, 600, 700, 800, 900, 1000];
alpha_u_values = [0.001, 0.005, 0.01, 0.015, 0.02];
alpha_m_values = [0.001, 0.005, 0.01, 0.015, 0.02];
beta_u_values = [100, 250, 500, 750, 1000];
beta_m_values = [100, 250, 500, 750, 1000];

gu_max = gu_max_values(consumerAffinity); % Max Consumer Affinity
gm_max = gm_max_values(developerAffinity); % Max Developer Affinity
alpha_u = alpha_u_values(consumerGrowthSensitivity); % Consumer Growth Sensitivity
alpha_m = alpha_m_values(developerGrowthSensitivity); % Developer Growth Sensitivity
beta_u = beta_u_values(consumerSaturation); % Consumer Saturation Point
beta_m = beta_m_values(developerSaturation); % Developer Saturation Point

% Initial Conditions
nu = initialConsumers; % Initial number of consumers
nm = initialDevelopers; % Initial number of developers
timesteps = days; % Number of simulation steps

% Arrays to store the evolution of the market over time
nu_t = zeros(timesteps, 1);
nm_t = zeros(timesteps, 1);

% --- SIMULATION ---
% This loop simulates the market dynamics over the specified timesteps
for t = 1:timesteps
    % Calculate the affinity (attractiveness) from the number of developers to consumers and vice versa
    gu = gu_max / (1 + exp(-alpha_u * (nm - beta_u)));
    gm = gm_max / (1 + exp(-alpha_m * (nu - beta_m)));
    
    % Update the number of consumers and developers
    nu_new = (1 - epsilon1) * nu + epsilon2 * gu;
    nm_new = (1 - epsilon3) * nm + epsilon4 * gm;
    
    % Store the updated numbers for plotting
    nu_t(t) = nu_new;
    nm_t(t) = nm_new;
    
    % Set up for the next iteration
    nu = nu_new;
    nm = nm_new;
end

% --- PLOTTING RESULTS ---
% Plotting the evolution of the number of consumers and developers on the same plot
figure;
plot(nu_t, 'b', 'LineWidth', 2);
hold on;
plot(nm_t, 'r', 'LineWidth', 2);
title('Evolution of Consumers and Developers in a Two-Sided Market');
xlabel('Time Step');
ylabel('Number of Participants');
legend({'Consumers', 'Developers'});
grid on;
