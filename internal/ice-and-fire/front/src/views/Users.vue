<template>
    <layout>
        <b-row class="my-auto justify-content-center">
            <b-carousel
                id="carousel-1"
                :interval="8000"
                controls
                indicators
                background="#ababab"
                img-width="500"
                img-height="200"
                style="text-shadow: 1px 1px 2px #333;"
            >
                <!-- Slide with blank fluid image to maintain slide aspect ratio -->
                <b-carousel-slide
                    :caption="username"
                    img-blank
                    img-alt="Blank image"
                    v-for="username of usernames"
                    v-bind:key="username"
                >
                    <p>Possible match for you!</p>
                    <b-button
                        class="mb-3"
                        variant="success"
                        @click="checkMatch(username)"
                        >Check match!</b-button
                    >
                </b-carousel-slide>
            </b-carousel>
        </b-row>
        <b-row class="justify-content-center">
            <b-button
                id="me-button"
                class="mt-5 col-3"
                variant="primary"
                @click="toggleTooltip()"
                v-b-tooltip.click
                >My data</b-button
            >
            <b-tooltip target="me-button">
                <p>Username: {{ myUsername }}</p>
                <p>Password: {{ myPassword }}</p>
                <p>Contact: {{ myContact }}</p>
            </b-tooltip>
        </b-row>
    </layout>
</template>

<script>
import Layout from '@/layouts/Layout';
import { UserList, MatchRequest, Match, MyData } from '@/proto/structs_pb';
export default {
    components: {
        Layout
    },
    created: async function() {
        let rawResp = null;
        try {
            rawResp = await this.$http.get('/users/', {
                responseType: 'arraybuffer'
            });
        } catch (e) {
            rawResp = e.response;
        }
        let resp = UserList.deserializeBinary(rawResp.data);
        this.usernames = resp.getUsernameList();
        console.log(this.usernames);
    },
    data() {
        return {
            usernames: [],
            hideTooltip: true,
            myUsername: '',
            myPassword: '',
            myContact: ''
        };
    },
    methods: {
        async toggleTooltip() {
            if (this.hideTooltip) {
                if (!this.myUsername) {
                    let rawResp = null;
                    try {
                        rawResp = await this.$http.get('/me/', {
                            responseType: 'arraybuffer'
                        });
                    } catch (e) {
                        rawResp = e.response;
                    }
                    let resp = MyData.deserializeBinary(rawResp.data);
                    this.myUsername = resp.getUser().getUsername();
                    this.myPassword = resp.getUser().getPassword();
                    this.myContact = resp.getContact().getText();
                }
            }
            this.hideTooltip = !this.hideTooltip;
        },
        async checkMatch(username) {
            console.log(username);
            let mr = new MatchRequest();
            mr.setUsername(username);

            let rawResp = null;
            try {
                rawResp = await this.$http.post(
                    '/match/',
                    mr.serializeBinary(),
                    {
                        responseType: 'arraybuffer',
                        headers: { 'Content-Type': 'application/octet-stream' }
                    }
                );
            } catch (e) {
                rawResp = e.response;
            }
            let resp = Match.deserializeBinary(rawResp.data);
            let ok = resp.getOk();
            if (ok) {
                alert(
                    `You are a perfect match! Here's the contact for you: ${resp
                        .getContact()
                        .getText()}. Good luck!`
                );
            } else {
                alert(
                    `You are not a match! Your distance is ${resp.getDistance()} :(`
                );
            }
        }
    }
};
</script>
