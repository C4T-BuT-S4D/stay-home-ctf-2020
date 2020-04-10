<template>
    <layout>
        <div class="row">
            <div class="twelve columns text-center"><br/>
                <h5 style="color: white;">Information about your friends crashes:</h5>
            </div>
        </div>

        <div v-for="(crash) in crashes" :key="crash.getSpaceshipAccessToken()" class="twelve columns text-center"
             style="width: 75%; padding-left: 25%"><br/>
            <div class="callout small">
                <p>Spaceship with token <b>{{ crash.getSpaceshipAccessToken() }}</b></p>
                <div v-if="crash.getCoordinates()">
                    <p>is wrecked on: ({{crash.getCoordinates().getLatitude()}},
                        {{crash.getCoordinates().getLatitude()}})</p>
                    <p>In {{ crash.getCoordinates().getDistance()}} space years from {{
                        crash.getCoordinates().getNearestPlanet() }}</p>
                </div>


            </div>
        </div>

    </layout>
</template>
<script>
    import Layout from './Layout';
    import {GetCrashesRequest} from '@/spacesos_pb.js';

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
                let req = new GetCrashesRequest();
                req.setSessionid(this.$store.state.sessionId);
                let resp = await this.$client.getCrashes(req, {});
                this.crashes = resp.getCrashesList();
            } catch (e) {
                this.$toasted.error(e.message);
            }
        }
    };
</script>
