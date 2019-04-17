#!/bin/bash -e

export PROV_CONTEXT=$1
export PROV_ENV=$2
export TF_FOLDER="$PROV_CONTEXT-$PROV_ENV"
export RES_STATE=$PROV_CONTEXT"_"$PROV_ENV"_state"

test_context() {
  echo "PROV_CONTEXT=$PROV_CONTEXT"
  echo "PROV_ENV=$PROV_ENV"
  echo "TF_FOLDER=$TF_FOLDER"
  echo "RES_STATE=$RES_STATE"
}

arch_statefile() {
  pushd "$TF_FOLDER"
  if [ -f "terraform.tfstate" ]; then
    echo "new state file exists, copying"
    echo "-----------------------------------"
    shipctl copy_file_to_resource_state terraform.tfstate $RES_STATE
  else
    # this is a safety measure, if this existed, the above if itself would have
    # yielded a state file
    local prev_state_loc="$JOB_PREVIOUS_STATE/terraform.tfstate"
    if [ -f "$prev_state_loc" ]; then
      echo "previous state file exists, copying $prev_state_loc"
      echo "-----------------------------------"
      shipctl copy_file_to_resource_state $prev_state_loc $RES_STATE
    else
      echo "No previous state file exists at $prev_state_loc, skip copying"
      echo "-----------------------------------"
    fi
  fi
  popd
}

main() {
  test_context
  arch_statefile
}

main
