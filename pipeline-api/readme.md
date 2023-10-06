To start the server:

Go to the settings of the repo and create an acess token. Copy this somewhere safe, you won't be able to see it again on the site. 

Create a file named ".env" with the following:

BITBUCKET_TOKEN=YOUR_ACESS_TOKEN

type npm start into the console

vue-router installation command
npm install vue-router


endpoints:

MongoDB Setup 
install MongoDB Community
https://www.mongodb.com/try/download/community

add pipelines/pipelines

install Mongo Shell for mongosh 
https://www.mongodb.com/try/download/shell
brew install mongosh for mac 

open new terminal and run mongosh


http://localhost:3000/bitbucket 

















const express = require('express');
const mongoose = require('mongoose');
const usersRouter = require('./routes/users-routing'); // Import the users route

const app = express();
app.use(express.json());

// Replace with your MongoDB connection string
const uri = 'mongodb://localhost:27017/pipelines';

mongoose.connect(uri, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error(err));

app.use('/users', usersRouter); // Use the users route as middleware

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});


Payload =====================================================
{
    "type": "repository",
    "full_name": "bpomerenkelabs/test-pipeline",
    "links": {
        "self": {
            "href": "https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline"
        },
        "html": {
            "href": "https://bitbucket.org/bpomerenkelabs/test-pipeline"
        },
        "avatar": {
            "href": "https://bytebucket.org/ravatar/%7Bf3068605-1bdd-4c38-99e2-91d8e33e993d%7D?ts=default"
        },
        "pullrequests": {
            "href": "https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline/pullrequests"
        },
        "commits": {
            "href": "https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline/commits"
        },
        "forks": {
            "href": "https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline/forks"
        },
        "watchers": {
            "href": "https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline/watchers"
        },
        "branches": {
            "href": "https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline/refs/branches"
        },
        "tags": {
            "href": "https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline/refs/tags"
        },
        "downloads": {
            "href": "https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline/downloads"
        },
        "source": {
            "href": "https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline/src"
        },
        "clone": [
            {
                "name": "https",
                "href": "https://eqxbiq4civknc0p2j0w67kwsjedcab@bitbucket.org/bpomerenkelabs/test-pipeline.git"
            },
            {
                "name": "ssh",
                "href": "git@bitbucket.org:bpomerenkelabs/test-pipeline.git"
            }
        ],
        "hooks": {
            "href": "https://api.bitbucket.org/2.0/repositories/bpomerenkelabs/test-pipeline/hooks"
        }
    },
    "name": "test-pipeline",
    "slug": "test-pipeline",
    "description": "",
    "scm": "git",
    "website": null,
    "owner": {
        "display_name": "Ben Pomerenke Labs",
        "links": {
            "self": {
                "href": "https://api.bitbucket.org/2.0/workspaces/%7Bb32e743d-61e7-43ae-958b-d0312595af68%7D"
            },
            "avatar": {
                "href": "https://bitbucket.org/account/bpomerenkelabs/avatar/"
            },
            "html": {
                "href": "https://bitbucket.org/%7Bb32e743d-61e7-43ae-958b-d0312595af68%7D/"
            }
        },
        "type": "team",
        "uuid": "{b32e743d-61e7-43ae-958b-d0312595af68}",
        "username": "bpomerenkelabs"
    },
    "workspace": {
        "type": "workspace",
        "uuid": "{b32e743d-61e7-43ae-958b-d0312595af68}",
        "name": "Ben Pomerenke Labs",
        "slug": "bpomerenkelabs",
        "links": {
            "avatar": {
                "href": "https://bitbucket.org/workspaces/bpomerenkelabs/avatar/?ts=1682717260"
            },
            "html": {
                "href": "https://bitbucket.org/bpomerenkelabs/"
            },
            "self": {
                "href": "https://api.bitbucket.org/2.0/workspaces/bpomerenkelabs"
            }
        }
    },
    "is_private": true,
    "project": {
        "type": "project",
        "key": "COD",
        "uuid": "{a02a4c5d-668b-40c8-91fe-3dd6cb877133}",
        "name": "codefi-pipeline-visualizer",
        "links": {
            "self": {
                "href": "https://api.bitbucket.org/2.0/workspaces/bpomerenkelabs/projects/COD"
            },
            "html": {
                "href": "https://bitbucket.org/bpomerenkelabs/workspace/projects/COD"
            },
            "avatar": {
                "href": "https://bitbucket.org/account/user/bpomerenkelabs/projects/COD/avatar/32?ts=1682716866"
            }
        }
    },
    "fork_policy": "no_public_forks",
    "created_on": "2023-04-28T21:27:23.979085+00:00",
    "updated_on": "2023-05-01T23:14:57.312975+00:00",
    "size": 133317,
    "language": "",
    "has_issues": false,
    "has_wiki": false,
    "uuid": "{f3068605-1bdd-4c38-99e2-91d8e33e993d}",
    "mainbranch": {
        "name": "main",
        "type": "branch"
    },
    "override_settings": {
        "default_merge_strategy": true,
        "branching_model": true
    }
}
