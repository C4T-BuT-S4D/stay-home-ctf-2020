<template>
    <layout>
        <div class="row">
            <div class="twelve columns text-center"><br/>
                <h3 style="color: white;">Welcome to spacesos. Service for alerting about space crashes.</h3>
            </div>
        </div>

        <form v-if="loggedIn" @submit="addCrush">
            <div class="grid-container">
                <h4 style="color: whitesmoke;">Commit a crash</h4>
                <div class="grid-x grid-padding-x text-center">
                    <div class="medium-4 cell">
                        <label style="color:whitesmoke;">Computer access token
                            <input type="text" v-model="token" required placeholder="poehali">
                        </label>
                    </div>
                </div>
                <h4 style="color:whitesmoke">Coordinates:</h4>
                <div class="grid-x grid-padding-x text-center">
                    <div class="medium-2 cell">
                        <label style="color:whitesmoke;">Nearest planet
                            <input type="text" v-model="planet" required placeholder="Earth">
                        </label>
                    </div>
                    <div class="medium-2 cell">
                        <label style="color:whitesmoke;">Distance
                            <input type="number" v-model="distance" required placeholder="3.14">
                        </label>
                    </div>
                </div>
                <div class="grid-x grid-padding-x text-center">
                    <div class="medium-2 cell">
                        <label style="color:whitesmoke;">Latitude
                            <input type="number" v-model="latitude" placeholder="3.14">
                        </label>
                    </div>
                    <div class="medium-2 cell">
                        <label style="color:whitesmoke;">Longitude
                            <input type="number" v-model="longitude" placeholder="3.14">
                        </label>
                    </div>
                </div>
                <div class="medium-2 cell">
                    <fieldset>
                        <legend style="color: whitesmoke">Expose coordinates and name:</legend>
                        <input id="checkbox1" type="checkbox" v-model="expose">
                        <label for="checkbox1" style="color: whitesmoke; ">{{ expose }}</label>
                    </fieldset>
                </div>
                <button class="button success" type="submit">Submit</button>
            </div>
        </form>
    </layout>
</template>
<script>
    import Layout from './Layout';
    import {Coordinates, Crash, CrashRequest} from '@/spacesos_pb.js';
    import {Timestamp} from 'google-protobuf/google/protobuf/timestamp_pb.js'

    export default {
        data: function () {
            return {
                token: "",
                latitude: 0,
                longitude: 0,
                distance: 0,
                planet: "",
                expose: false,
            };
        },
        methods: {
            async addCrush(event) {
                event.preventDefault();
                let time = new Timestamp();
                time.setSeconds(Date.now());
                let coordinates = new Coordinates();
                coordinates.setNearestPlanet(this.planet);
                coordinates.setLongitude(this.longitude);
                coordinates.setLatitude(this.latitude);
                coordinates.setDistance(this.distance);
                let crash = new Crash();
                crash.setCoordinates(coordinates);
                crash.setTime(time);
                crash.setSpaceshipAccessToken(this.token);
                let request = new CrashRequest();
                request.setCrash(crash);
                request.setSessionid(this.$store.state.sessionId);
                request.setExpose(this.expose);
                try {
                    let resp = await this.$client.crash(request, {});
                    let result = resp.getResult();
                    this.$toasted.info(result, {duration: 15 * 1000});
                    this.$router.push({ name: 'Crashes' });
                } catch (e) {
                    this.$toasted.error(e.message);
                }
            },
        },
        computed: {
            loggedIn() {
                return this.$store.state.sessionId != null;
            },
        },
        components: {
            Layout
        },

    };
</script>
