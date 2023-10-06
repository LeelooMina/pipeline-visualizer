const express = require('express');
const router = express.Router();
const { 
  fetchBitbucketData, 
  fetchBitbucketBranches, 
  fetchBitbucketPipelines, 
  fetchPipelineSteps,
  fetchBitbucketPipeline
} = require('../services/bitbucket');


router.get('/', async (req, res) => {
  try {
    const data = await fetchBitbucketData();
    res.send(data);
  } catch (error) {
    console.error(error);
    res.status(500).send(error);
  }
});

router.get('/branches', async (req, res) => {
  try {
    const data = await fetchBitbucketBranches();
    res.send(data);
  } catch (error) {
    console.error(error);
    res.status(500).send('Error fetching Bitbucket data');
  }
});

router.get('/pipelines', async (req, res) => {
  try {
    const data = await fetchBitbucketPipelines();
    res.send(data);
  } catch (error) {
    console.error(error);
    res.status(500).send('Error fetching Bitbucket pipelines data');
  }
});

router.get('/pipeline/:uuid', async (req, res) => {
  try {
    
    const data = await fetchBitbucketPipeline(req.params.uuid);
    res.send(data);
  } catch (error) {
    console.error(error);
    res.status(500).send(error);
  }
});

router.get('/pipeline/steps/:uuid', async (req, res) => {
  try {
    
    const data = await fetchPipelineSteps(req.params.uuid);
    res.send(data);
  } catch (error) {
    console.error(error);
    res.status(500).send(error);
  }
});



module.exports = router;




