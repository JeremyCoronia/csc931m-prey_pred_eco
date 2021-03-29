# csc931m-prey_pred_eco

## Description about the Model

This model shows a simple predator-prey ecosystem. Predators wander around and eat prey, while prey also wander around but eat grass. The current population sizes of each agent can be monitored during a simulation, and a plot shows the fluctations in population of each agent over time.

## Agents

In this given model, the predators are wolves (black) while the prey is sheep (white). Patches of the environment colored green are grass that can be eaten.

Both prey and predator have energy levels, and each one has their respective ways to maintain them. If any given predator or prey cannot maintain their energy level (i.e., the value is equal to 0), then the agent will die.

How big of a "step" or the degree in which they turn during movement can be modified by the user with the `max-turn` and `max-step` settings. 

### Grass
The grass in this model are patches of the environment that are colored green. This is grass that can be eaten by sheep. Otherwise, the patches will be brown, which cannot be eaten by sheep.

Grass regrows by a fixed amount of time that is counted down during a simulation. This time  can be set by the user during setup. 

### PREY: Sheep
Sheep are colored white in the environment, and they are considered prey. Sheep will wander randomly around the environment during a simulation and attempt to eat _green_ grass to maintain their energy.

Settings that can be modified by the user for the sheep is their:
1. Initial population size
2. The probability of reduction at each time step
3. How much energy is added per patch of grass eaten

### PREDATOR: Wolves
Wolves are colored black in the environment, and they are considered predators. Wolves will also wander randomly around the environment and attempt to eat sheep if they encounter them to maintain their energy.

Settings that can be modified by the user for the wolf is their:
1. Initial population size
2. The probability of reduction at each time step
3. How much energy is added per sheep eaten
