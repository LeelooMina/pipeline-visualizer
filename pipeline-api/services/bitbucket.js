 const axios = require('axios');
const Build = require('../models/build');
require('dotenv').config();

// Function to extract pipelines ======================================================
async function extractPipelines(pipelines) {
  const pipelineArr = [];

  await Promise.all(Object.values(pipelines).map(async (pipeline) => {
    const steps = await fetchPipelineSteps(pipeline.uuid)
    console.log(pipeline)
    const model = {
      number: pipeline.build_number,
      branch_name: pipeline.target.ref_name,
      uuid: pipeline.uuid,
      status: pipeline.state.result?.name,
      duration_seconds: pipeline.duration_in_seconds,
      steps: steps,
      created_on: pipeline.created_on,
      completed_on: pipeline.completed_on
    };
    pipelineArr.push(model);
    console.log(model)
  }));
  return pipelineArr;
}

// Function to store build data ============================================================
function storeBuilds(builds){
  const buildArr = JSON.parse(builds).map(res => {
    const steps = [];
    res.steps.forEach(step => {
      steps.push[{status: step.status, duration: step.duration}]
    });
    return new Build(res.number, res.name, res.status, res.duration, steps)
  })

  return buildArr;
}

// Function to extract pipeline steps ======================================================
function extractPipelineSteps(pipelineSteps) {
  const stepArr = [];

  Object.values(pipelineSteps).forEach((step) => {
    const model = {
      name: step.name,
      result: step.state.result ? step.state.result.name : 'Unknown Result',
      started_on: step.started_on,
      duration_seconds: step.duration_in_seconds,
      completed_on: step.completed_on
    };
   
  
    stepArr.push(model);
  });
  
  return stepArr;
}




// Function to fetch Bitbucket data ===================================================================
async function fetchBitbucketData() {
  const url = 'https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline';
  
  const config = {
    headers: {
      'Authorization': `Bearer ${process.env.BITBUCKET_TOKEN}`
    }
  };
  const response = await axios.get(url, config);
  if (response.status === 200) {
    return response.data;
  } else {
    throw new Error('Error fetching Bitbucket data');
  }
}

// Function to store branch data ============================================================
function storeBranches(branches){

}

// Function to fetch Bitbucket branches ======================================================
async function fetchBitbucketBranches() {
  const url = 'https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline/refs/branches';
  
  const config = {
    headers: {
      'Authorization': `Bearer ${process.env.BITBUCKET_TOKEN}`
    }
  };
  const response = await axios.get(url, config);
  if (response.status === 200) {
    return response.data;
  } else {
    throw new Error('Error fetching Bitbucket data');
  }
}

// URL to fetch last 4 pipelines: https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline/pipelines/?sort=-created_on&pagelen=4
// Function to fetch Bitbucket pipelines ======================================================
async function fetchBitbucketPipelines() {
  const url = 'https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline/pipelines/?sort=-created_on&pagelen=5';
  
  const config = {
    headers: {
      'Authorization': `Bearer ${process.env.BITBUCKET_TOKEN}`
    }
  };
  const response = await axios.get(url, config);
  if (response.status === 200) {
    data = extractPipelines(response.data.values)
    return data;
  } else {
    throw new Error('Error fetching Bitbucket data');
  }
}

async function fetchBitbucketPipeline(uuid) {
  const url = `https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline/pipelines/${uuid}`;
  
  const config = {
    headers: {
      'Authorization': `Bearer ${process.env.BITBUCKET_TOKEN}`
    }
  };
  const response = await axios.get(url, config);
  if (response.status === 200) {
    data = extractPipelines(response.data)
    return data;
  } else {
    throw new Error('Error fetching Bitbucket data');
  }
}

async function extractPipelines(pipelines) {
  const pipelineArr = [];

  // Check if input is an array or a single object
  if (Array.isArray(pipelines)) {
    // If it's an array, map through it
    await Promise.all(pipelines.map(async (pipeline) => {
      const steps = await fetchPipelineSteps(pipeline.uuid)
      console.log(pipeline.created_on)
      const model = {
        build_number: pipeline.build_number,
        branch_name: pipeline.target.ref_name,
        uuid: pipeline.uuid,
        status: pipeline.state.result?.name,
        duration_seconds: pipeline.duration_in_seconds,
        steps: steps,
        created_on: pipeline.created_on,
        completed_on: pipeline.completed_on
      };
      pipelineArr.push(model);
    }));
  } else {
    const steps = await fetchPipelineSteps(pipelines.uuid)
  
    const model = {
      build_number: pipeline.build_number,
      branch_name: pipeline.target.ref_name,
      uuid: pipeline.uuid,
      status: pipeline.state.result?.name,
      duration_seconds: pipeline.duration_in_seconds,
      steps: steps,
      created_on: pipeline.created_on,
      completed_on: pipeline.completed_on
    };
    pipelineArr.push(model);
  }
  return pipelineArr;
}

// Function to fetch Bitbucket pipeline steps ======================================================
async function fetchPipelineSteps(uuid) {
  // console.log(uuid)
  const url = `https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline/pipelines/${uuid}/steps`;
  
  const config = {
    headers: {
      'Authorization': `Bearer ${process.env.BITBUCKET_TOKEN}`
    }
  };
  const response = await axios.get(url, config);
  if (response.status === 200) {
    const piplineSteps = extractPipelineSteps(response.data.values)
    return piplineSteps;
  } else {
    throw new Error('Error fetching Bitbucket data');
  }
}


  



module.exports = {fetchBitbucketData, fetchBitbucketBranches, fetchBitbucketPipelines, fetchPipelineSteps }
// const axios = require('axios');
require('dotenv').config();

async function fetchBitbucketData() {
  const url = 'https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline';
  
  const config = {
    headers: {
      'Authorization': `Bearer ${process.env.BITBUCKET_TOKEN}`
    }
  };
  const response = await axios.get(url, config);
  if (response.status === 200) {
   
    return response.data;
  } else {
    throw new Error('Error fetching Bitbucket data');
  }
}



async function fetchBitbucketBranches() {
  const url = 'https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline/refs/branches';
  
  const config = {
    headers: {
      'Authorization': `Bearer ${process.env.BITBUCKET_TOKEN}`
    }
  };
  const response = await axios.get(url, config);
  if (response.status === 200) {
    
    return response.data;
  } else {
    throw new Error('Error fetching Bitbucket data');
  }
}

module.exports = {fetchBitbucketData, fetchBitbucketBranches, fetchBitbucketPipeline, fetchBitbucketPipelines }
