#!/bin/bash

# Name of the job
#SBATCH --job-name=dorry_w1_rs_xcpd

# Partition on GACRC to run job
#SBATCH --partition=batch 

# Number of tasks
#SBATCH --ntasks=1

# Number of compute nodes
#SBATCH --nodes=1

# Number of CPUs per task
#SBATCH --cpus-per-task=16

# Request memory
#SBATCH --mem=50G

# save logs 
#SBATCH --output=/work/cglab/projects/DORRY/slurm_logs/xcpd_log_array_%A-%a.out
#SBATCH --error=/work/cglab/projects/DORRY/slurm_logs/xcpd_error_array_%A-%a.err

# Walltime (job duration)
#SBATCH --time=36:00:00

# Array jobs (* change the range according to # of subject; % = number of active job array tasks)
#SBATCH --array=1-103%15

# Email notifications (*comma-separated options: BEGIN,END,FAIL)
#SBATCH --mail-type=BEGIN,END,FAIL


# Parameters
participants=(1002 1006 1007 1008 1010 1011 1012 1013 1014 1015 1016 1017 1018 1019 1020 1021 1026 1027 1028 1029 1030 1031 1032 1033 1034 1035 1036 1037 1038 1039 1041 1042 1044 1048 1049 1051 1052 1053 1055 1058 1059 1060 1061 1062 1063 1064 1066 1068 1069 1072 1073 1076 1078 1079 1081 1082 1084 1085 1086 1088 1090 1091 1092 1093 1094 1096 1102 1103 1105 1106 1107 1108 1109 1110 1111 1112 1113 1114 1115 1116 1117 1118 1119 1120 1121 1122 1124 1125 1126 1127 1128 1138 1140 1141 1142 1143 1146 1149 1150 1151 1152 1154 1155)
PARTICIPANT_LABEL=${participants[(${SLURM_ARRAY_TASK_ID} - 1)]}
BIDS_DIR=/work/cglab/projects/DORRY/BIDS/RS/derivatives/
OUTPUT_DIR=/work/cglab/projects/DORRY/BIDS/RS/derivatives_xcpd/
WORK_DIR=/work/cglab/projects/DORRY/work/xcpd/
XCPD_RESOURCES_PATH=/work/cglab/containers/

echo "array id: " ${SLURM_ARRAY_TASK_ID}, "subject id: " ${PARTICIPANT_LABEL}

singularity run \
                --cleanenv \
                -B $HOME:/home/xcp \
                --home /home/xcp \
                -B ${XCPD_RESOURCES_PATH}:/resources \
                -B ${BIDS_DIR}:/data \
                -B ${WORK_DIR}:/work \
                -B ${OUTPUT_DIR}:/output \
        ${XCPD_RESOURCES_PATH}/xcp_d-0.7.1rc6.sif /data /output \
        participant --participant_label $PARTICIPANT_LABEL \
        -w /work \
        --input-type fmriprep \
        --motion-filter-type notch \
        --band-stop-min 15 \
        --band-stop-max 25 \
        --nuisance-regressors 36P \
        --despike \
        --smoothing 4 \
        --exact-time 30 \
        --nthreads 16 \
        --fs-license-file /resources/.licenses/freesurfer/license.txt