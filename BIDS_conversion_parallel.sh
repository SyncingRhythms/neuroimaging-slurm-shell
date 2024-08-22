#!/bash/bin

parallel --plus dcm2bids --auto_extract_entities --force_dcm2bids -c code/dcm2bids_config_rs-t1.json -d {} -p {/..} ::: /work/cglab/projects/DORRY/BIDS/RS_W2/sourcedata/*