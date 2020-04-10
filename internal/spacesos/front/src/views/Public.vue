<template>
    <layout>
        <div class="row">
            <div class="twelve columns text-center"><br/>
                <h5 style="color: white;">Information about latest crashes:</h5>
            </div>
        </div>

        <div v-for="(crash) in crashes" :key="crash.getUser()" class="twelve columns text-center"
             style="width: 75%; padding-left: 25%"><br/>
            <div class="callout small">
                <p>Spaceship: <b>{{ crash.getUser() }}</b></p>
                <p>is wrecked on: ({{crash.getCoordinates().getLatitude()}},
                    {{crash.getCoordinates().getLatitude()}})</p>
                <p>In {{ crash.getCoordinates().getDistance()}} space years from {{
                    crash.getCoordinates().getNearestPlanet()}}</p>

            </div>
        </div>

    </layout>
</template>
<script>
    import Layout from './Layout';
    import {GetLatestCrashesRequest} from '@/spacesos_pb.js';

    export default {
        data: function () {
            return {
                crashes: [],
            };
        },
        components: {
            Layout
        },
        async mounted() {
            try {
                let req = new GetLatestCrashesRequest();
                let resp = await this.$client.getLatestCrashes(req, {});
                this.crashes = resp.getCrashesList();
            } catch (e) {
                this.$toasted.error(e.message);
            }
        }
    };
</script>
