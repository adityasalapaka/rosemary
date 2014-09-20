Codebook for Rosemary
=====================

This codebook describes the data obtained in the final step of `run_analysis.R`,
namely `tidy_data.txt`. It must be imported into R using the `read.table()` 
function using the argument `row.names = TRUE`.

## Variables

- Subject
Subject ID of the participant. Ranges from 1 to 30.

- Activity
Activity labels for the activity each subject was performing. The original 
dataset had activiy IDs in another file, which was merged with the collected
data. The activity IDs ranged from 1 to 6. The activity IDs were replaced by
activiy labels which were provided in `features.txt`.

1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING


