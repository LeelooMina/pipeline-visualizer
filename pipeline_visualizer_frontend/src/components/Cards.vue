<script lang="ts">
// imports necessary functions and components from vue and quasar.
import { defineComponent, ref, onMounted } from "vue";
import { useAuth0 } from "@auth0/auth0-vue";
import { QCard, QCardSection, QSeparator } from "quasar";

// Defines an interface for Steps data. This defines the shape of the data we expect to fetch from the API.
interface Step {
  _id?: string;
  name: string;
  result?: string;
  started_on?: string;
  duration_seconds: number;
  completed_on?: string;
}

// Defines an interface for Pipeline data. This defines the shape of the data we expect to fetch from the API.
interface Pipeline {
  _id: string;
  build_number: number;
  branch_name: string;
  uuid: string;
  status: string;
  duration_seconds: number;
  build_seconds_used?: number;
  steps: Step[];
  started_on?: string;
  created_on?: string;
  completed_on?: string;
}

export default defineComponent({
  components: {
    QCard,
    QCardSection,
    QSeparator,
  },
  setup() {
    // Creates a ref to hold our pipelines data.
    const pipelines = ref<Pipeline[]>([]);

    // Initialize expansion states. Only the first two are expanded.
    const expansionStates = ref<Array<boolean>>([]);

    // Creates an async function to fetch the pipelines data.
    const fetchData = async () => {
      try {
        const auth0 = useAuth0();
        const token = await auth0.getAccessTokenSilently();
        console.log("token: ", token);
        const response = await fetch("http://localhost:3000/pipelines", {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
        const data = await response.json();
        pipelines.value = data;
        console.log("W", pipelines);

        // only update expansionStates if a new pipeline was added
        if (data.length > expansionStates.value.length) {
          // for new pipelines, expand the first two and collapse the rest
          const newExpansionStates = data.map((_, index) => index < 2);
          expansionStates.value = newExpansionStates;
        }
      } catch (error) {
        console.error("Error fetching pipelines:", error);
      }
    };

    fetchData();
    setInterval(fetchData, 10000);

    // When the component is mounted, we fetch the data.
    onMounted(() => {
      fetchData();
    });

    const getPipelineColor = (status: string) => {
      switch (status) {
        case "SUCCESSFUL":
          return "#1a1a66";
        case "FAILED":
          return "#961c48";
        case "Unknown Result":
          return "#e67700";
        case "NOT_RUN":
          return "grey";
        default:
          return "#e67700";
      }
    };

    const getStepColor = (result: string | undefined) => {
      // console.log('getStepColor called with result:', result);
      switch (result) {
        case "SUCCESSFUL":
          return "#1a1a66";
        case "FAILED":
          return "#961c48";
        case "Unknown Result":
          return "#e67700";
        case "NOT_RUN":
          return "grey";
        default:
          return "grey";
      }
    };

    // We expose the pipelines ref to our template.
    return {
      pipelines,
      getStepColor,
      getPipelineColor,
      expansionStates,
    };
  },
});
</script>

<template>
  <div class="card-container">
    <div
      v-for="(pipeline, index) in pipelines"
      :key="pipeline._id"
      bordered
      class="my-card"
    >
      <div class="q-pa-md test" style="padding: 0">
        <div
          class="q-pa-md test"
          style="padding: 0; background-color: lightgrey"
        >
          <q-expansion-item v-model="expansionStates[index]">
            <template v-slot:header>
              <div
                :style="{ backgroundColor: getPipelineColor(pipeline.status) }"
                class="expansion-header"
              >
                {{ pipeline.branch_name }} branch
                <span
                  v-if="getPipelineColor(pipeline.status) === '#e67700'"
                  class="header-loader"
                ></span>
              </div>
            </template>

            <!-- ================================================================ ROW 2 ================================================================ -->

            <div class="row">
              <div class="col-3">
                <div
                  v-if="pipeline.steps.length > 0"
                  class="pipeline-steps"
                  :style="{
                    backgroundColor: getStepColor(pipeline.steps[0].result),
                  }"
                >
                  <span
                    v-if="getStepColor(pipeline.steps[0].result) === '#e67700'"
                    class="loader"
                  ></span>
                  <h4
                    v-show="
                      getStepColor(pipeline.steps[0].result) !== '#e67700'
                    "
                  >
                    {{ pipeline.steps[0].duration_seconds }}S
                  </h4>
                  <p class="step-text">{{ pipeline.steps[0].name }}</p>
                </div>
                <div v-else>No Steps Available</div>
              </div>

              <div class="col details-positioning">
                <h4 class="branch-name">Branch {{ pipeline.branch_name }}</h4>
              </div>
              <div class="col">
                <p class="build-info">
                  Build Number: {{ pipeline.build_number }}
                </p>
                <p class="build-info">
                  Total Time: {{ pipeline.duration_seconds || "N/A" }}S
                </p>
                <p class="build-info">
                  Last Activity: {{ pipeline.created_on }}
                </p>
              </div>
            </div>

            <!-- ================================================================ ROW 2 ================================================================ -->

            <div class="row row-2">
              <div class="col card-color">
                <div
                  v-if="pipeline.steps.length > 0"
                  class="pipeline-steps"
                  :style="{
                    backgroundColor: pipeline.steps[1].result
                      ? getStepColor(pipeline.steps[1].result)
                      : 'grey',
                  }"
                >
                  <span
                    v-if="getStepColor(pipeline.steps[1].result) === '#e67700'"
                    class="loader"
                  ></span>
                  <h4
                    v-show="
                      getStepColor(pipeline.steps[1].result) !== '#e67700'
                    "
                  >
                    {{ pipeline.steps[1].duration_seconds }}S
                  </h4>
                  <p class="step-text">{{ pipeline.steps[1].name }}</p>
                </div>
                <div v-else>No Steps Available</div>
              </div>

              <div class="col card-color">
                <div
                  v-if="pipeline.steps.length > 0"
                  class="pipeline-steps"
                  :style="{
                    backgroundColor: pipeline.steps[3].result
                      ? getStepColor(pipeline.steps[3].result)
                      : 'grey',
                  }"
                >
                  <span
                    v-if="getStepColor(pipeline.steps[3].result) === '#e67700'"
                    class="loader"
                  ></span>
                  <h4
                    v-show="
                      getStepColor(pipeline.steps[3].result) !== '#e67700'
                    "
                  >
                    {{ pipeline.steps[3].duration_seconds }}S
                  </h4>
                  <p class="step-text">{{ pipeline.steps[3].name }}</p>
                </div>
                <div v-else>No Steps Available</div>
              </div>
              <div class="col card-color">
                <div
                  v-if="pipeline.steps.length > 0"
                  class="pipeline-steps"
                  :style="{
                    backgroundColor: pipeline.steps[4].result
                      ? getStepColor(pipeline.steps[4].result)
                      : 'grey',
                  }"
                >
                  <span
                    v-if="getStepColor(pipeline.steps[4].result) === '#e67700'"
                    class="loader"
                  ></span>
                  <h4
                    v-show="
                      getStepColor(pipeline.steps[4].result) !== '#e67700'
                    "
                  >
                    {{ pipeline.steps[4].duration_seconds }}S
                  </h4>
                  <p class="step-text">{{ pipeline.steps[4].name }}</p>
                </div>
                <div v-else>No Steps Available</div>
              </div>
              <div class="col card-color">
                <div
                  v-if="pipeline.steps.length > 0"
                  class="pipeline-steps"
                  :style="{
                    backgroundColor: pipeline.steps[5].result
                      ? getStepColor(pipeline.steps[5].result)
                      : 'grey',
                  }"
                >
                  <span
                    v-if="getStepColor(pipeline.steps[5].result) === '#e67700'"
                    class="loader"
                  ></span>
                  <h4
                    v-show="
                      getStepColor(pipeline.steps[5].result) !== '#e67700'
                    "
                  >
                    {{ pipeline.steps[5].duration_seconds }}S
                  </h4>
                  <p class="">{{ pipeline.steps[5].name }}</p>
                </div>
                <div v-else>No Steps Available</div>
              </div>
            </div>

            <!-- ================================================================ ROW 3 ================================================================ -->

            <div class="row row-3">
              <div class="col card-color">
                <div
                  v-if="pipeline.steps.length > 0"
                  class="pipeline-steps"
                  :style="{
                    backgroundColor: pipeline.steps[2].result
                      ? getStepColor(pipeline.steps[2].result)
                      : 'grey',
                  }"
                >
                  <span
                    v-if="getStepColor(pipeline.steps[2].result) === '#e67700'"
                    class="loader center-text"
                    style="z-index: "
                  ></span>
                  <h4
                    v-show="
                      getStepColor(pipeline.steps[2].result) !== '#e67700'
                    "
                  >
                    {{ pipeline.steps[2].duration_seconds }}S
                  </h4>
                  <p class="step-text">{{ pipeline.steps[2].name }}</p>
                </div>
                <div v-else></div>
              </div>

              <div class="col">
                <div
                  v-if="pipeline.steps.length > 6 && pipeline.steps[6].result"
                  class="pipeline-steps"
                  :style="{
                    backgroundColor:
                      getStepColor(pipeline.steps[6].result) || 'grey',
                  }"
                >
                  <span
                    v-if="getStepColor(pipeline.steps[6].result) === '#e67700'"
                    class="loader"
                  ></span>
                  <h4
                    v-show="
                      getStepColor(pipeline.steps[6].result) !== '#e67700'
                    "
                  >
                    {{ pipeline.steps[6].duration_seconds }}S
                  </h4>
                  <p class="step-text">{{ pipeline.steps[6].name }}</p>
                </div>
                <div v-else-if="pipeline.steps.length > 0"></div>
                <div v-else></div>
              </div>
              <div class="col">
                <div
                  v-if="pipeline.steps.length > 7 && pipeline.steps[7].result"
                  class="pipeline-steps"
                  :style="{
                    backgroundColor:
                      getStepColor(pipeline.steps[7].result) || 'grey',
                  }"
                >
                  <span
                    v-if="getStepColor(pipeline.steps[7].result) === '#e67700'"
                    class="loader"
                  ></span>
                  <h4
                    v-show="
                      getStepColor(pipeline.steps[7].result) !== '#e67700'
                    "
                  >
                    {{ pipeline.steps[7].duration_seconds }}S
                  </h4>
                  <p class="step-text">{{ pipeline.steps[7].name }}</p>
                </div>
                <div v-else-if="pipeline.steps.length > 0"></div>
                <div v-else></div>
              </div>
              <div class="col">
                <div
                  v-if="pipeline.steps.length > 8 && pipeline.steps[8].result"
                  class="pipeline-steps"
                  :style="{
                    backgroundColor:
                      getStepColor(pipeline.steps[8].result) || 'grey',
                  }"
                >
                  <span
                    v-if="getStepColor(pipeline.steps[8].result) === '#e67700'"
                    class="loader center-text"
                  ></span>
                  <h4
                    v-show="
                      getStepColor(pipeline.steps[8].result) !== '#e67700'
                    "
                  >
                    {{ pipeline.steps[8].duration_seconds }}S
                  </h4>
                  <p class="step-text">{{ pipeline.steps[8].name }}</p>
                </div>
                <div v-else-if="pipeline.steps.length > 0"></div>
                <div v-else></div>
              </div>
            </div>
          </q-expansion-item>
          <q-separator />
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.test // margin-right: 100px

.my-card {
  flex: 1 0 auto;
  width: 100%;
  margin-right: 100px;
  padding-top: 20px;
}

@media (min-width: 420px) {
  .my-card {
    width: 100%;
    margin-right: 0;
  }
}

.card-container {
  display: flex;
  flex-wrap: wrap;
}

.build-info {
  margin-bottom: 0;
  font-size: 0.75rem;
}

.step-text {
  font-size: 1.5vh;
}

.center-text {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
}

.expansion-header {
  width: 100%;
  height: 20px;
  border-radius: 5px;
  color: white;
  text-align: center;
}

@media (max-width: 768px) {
  h4 {
    font-size: 1rem;
  }
}

@media (min-width: 768px) {
  h4 {
    font-size: 1.5rem;
  }
}

.pipeline-steps {
  position: relative;
  top: -20px;
  border-radius: 20px;
  color: white;
  margin-top: 2px;
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;

  p,
  h4,
  span {
    // Apply flex to these elements so they can be centered easily
    display: flex;
    justify-content: center;
    align-items: center;
  }

  h4 {
    // Remove inline-block
    // display: inline-block;
    // Center text horizontally
    text-align: center;
    margin-top: 1.5rem;
    margin-bottom: 1.5rem;
    color: orange;
  }

  span {
    padding-top: 10px;
    margin-left: 10px;
  }
}

.branch-name {
  margin-top: 0px;
  margin-bottom: 0px;
  padding-left: 40px;
}

.row-2 {
  margin-left: 1.5rem;
}

.row-3 {
  margin-left: 3rem;
}

.loader {
  width: 48px;
  height: 48px;
  margin-top: 1rem;
  margin-bottom: 1rem;
  border-radius: 50%;
  position: relative;
  animation: rotate 1s linear infinite;

  // Center the loader within its parent
  top: 50%;
  right: 5%;
  transform: translate(-50%, -50%);

  &::before,
  &::after {
    content: "";
    box-sizing: border-box;
    position: absolute;
    top: 0px;
    right: 0px;
    bottom: 0px;
    left: 0px;
    border-radius: 50%;
    border: 5px solid #fff;
    animation: prixClipFix 2s linear infinite;
  }

  &::after {
    top: 8px;
    right: 8px;
    bottom: 8px;
    left: 8px;
    transform: rotate3d(90, 90, 0, 180deg);
    border-color: #ff3d00;
  }
}

.header-loader {
  width: 18px;
  height: 18px;
  border-radius: 50%;
  position: relative;
  animation: rotate 1s linear infinite;

  &::before,
  &::after {
    content: "";
    box-sizing: border-box;
    position: absolute;
    top: 0px;
    right: 0px;
    bottom: 0px;
    left: 0px;
    border-radius: 50%;
    border: 5px solid #fff;
    animation: prixClipFix 2s linear infinite;
  }

  &::after {
    top: 8px;
    right: 8px;
    bottom: 8px;
    left: 8px;
    transform: rotate3d(90, 90, 0, 180deg);
    border-color: #ff3d00;
  }
}

@keyframes rotate {
  0% {
    transform: rotate(0deg);
  }

  100% {
    transform: rotate(360deg);
  }
}

@keyframes prixClipFix {
  0% {
    clip-path: polygon(50% 50%, 0 0, 0 0, 0 0, 0 0, 0 0);
  }

  50% {
    clip-path: polygon(50% 50%, 0 0, 100% 0, 100% 0, 100% 0, 100% 0);
  }

  100% {
    clip-path: polygon(50% 50%, 0 0, 100% 0, 100% 100%, 100% 100%, 100% 100%);
  }
}
</style>
