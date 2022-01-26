# Artificial Simulink Model Examples

This repository provides MATLAB scripts for generating Simulink models.

## Simulink model schemes

### Nested counter 

Script: `makeNestedCounterModel.m`

Parameters: `numNests`, `thres`

The intension of this model is that the entire system hierarchy must be analyzed to detect its dead logic.
The model describes `numNests` counters, each with a holding mode and resets the value after `thres` increments.
They are nested in such a way that each level increments when the inner counter resets;
the *i*-th level from the inside increments appropriately every (`thres`^`numNests`) steps.
When the top-level counter value reaches `thres`-1, it will force a hold on the innermost counter to prevent from a reset;
hence, the top-level reset is DL.

### Sequential integrators

Script: `makeSequentialIntegratorsModel.m`

Parameter: `numInts`

Models connect `numInts` integrators (a simple feedback loop system) in series.
We apply a gain $0.1$ to the output of each integrator so that the value becomes less than 1.
The increase rate should become smaller for subsequent output signals.
We put a `RelationalOperator` to check that the final output is less than 1;
its violation should be DL.

<br />

## License

This artifact is released under the APACHE 2.0 license, see `LICENSE.txt`.
