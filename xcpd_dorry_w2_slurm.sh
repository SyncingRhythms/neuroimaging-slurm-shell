#!/bin/bash

# Name of the job
#SBATCH --job-name=dorry_w2_rs_xcpd

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
#SBATCH --output=/work/cglab/projects/DORRY/slurm_logs/xcpd_w2_log_array_%A-%a.out
#SBATCH --error=/work/cglab/projects/DORRY/slurm_logs/xcpd_w2_error_array_%A-%a.err

# Walltime (job duration)
#SBATCH --time=36:00:00

# Array jobs (* change the range according to # of subject; % = number of active job array tasks)
#SBATCH --array=1-103%15

# Email notifications (*comma-separated options: BEGIN,END,FAIL)
#SBATCH --mail-type=BEGIN,END,FAIL


# Parameters
participants=(1026 1051 1069 1063 1035 1042 1138 1007 1094 1100 1148 1142 1038 1114 1013 1064 1128 1052 1025 1122 1017 1060 1084 1110 1146 1041 1036 1097 1103 1004 1073 1003 1067 1022 1028 1125 1018 1020 1057 1150 1127 1076 1143 1134 1039 1033 1101 1006 1050 1027 1118 1015 1062 1086 1068 1116 1082 1011 1066 1088 1054 1091 1008 1047 1140 1037 1040 1108 1096 1102 1154 1059 1024 1053 1085 1111 1061 1016)
PARTICIPANT_LABEL=${participants[(${SLURM_ARRAY_TASK_ID} - 1)]}
BIDS_DIR=/work/cglab/projects/DORRY/BIDS/RS_W2/derivatives/
OUTPUT_DIR=/work/cglab/projects/DORRY/BIDS/RS_W2/derivatives_xcpd/
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