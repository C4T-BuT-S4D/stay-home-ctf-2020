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
                    :img-src="images[index % images.length]"
                    img-alt="Blank image"
                    v-for="(username, index) of usernames"
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
    },
    data() {
        return {
            usernames: [],
            hideTooltip: true,
            myUsername: '',
            myPassword: '',
            myContact: '',
            images: [
                'https://cdn.mos.cms.futurecdn.net/URuhmbyEneGKo8UqAoZrf6-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/iB3z4tNs8nig8Qn9WsfHCX-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/uzbViMG76X2UJTKx9ZStbd-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/pKBh76PKW9Sa6wUrUmuBe-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/i2qvMyMDQfwWCzBFn8wPF6-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/YtjkTaKgzJp5wmqagtuuCd-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/hqE85NWQAFpPzB3Ad4DiE3-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/zmdDvb4rVWHiMvnax3L8YG-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/AVpSghh6LWz4XMvBi5ESCT-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/WRn8cVtctHM4PPehB2Z67n-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/Ga43bUtptaSsdhby6saALN-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/3nVmZz9czgqfsTaiVcckPo-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/kpjRj4c476TRyGiZySLn8b-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/dfrcgyieQQxEJ4eZXqgLSY-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/wPQe3zhHw6uZ63LVtVbMub-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/BsyfuCaqhvBhFfqsWa4uzR-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/3s4jmdZbVwZgiDUKAYcig4-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/kdAFtygU4v25frtyMMHwVA-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/Z2sa3oDBgpXkj7igPj6wiZ-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/gBjc7uFupgjae946nYtWMP-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/PX7N2P2bw2R7cfZjENfrXd-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/U4rnXBZ4n7x6NzGSv3TQCf-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/3nVmZz9czgqfsTaiVcckPo-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/Ky9BAKiNttY3boEMxKc7h9-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/2SokqPMypTU8W5Tab4dfsH-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/miWPjU9rz3ZqEKEVx6SvuH-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/Gjtp6omSGfyr3XnPCoxara-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/eJopsRgkETVJzoCVg9TZ57-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/3PRWNKmdJCpCaQP4Divnhj-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/He8xyNC7yKhxHdNJq7LqJC-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/3J7aNSNfmrVYojYTtqm6n7-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/amashdiEYtELvke33tnLa-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/jx3mUiG8YpP4fqHHwwou2U-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/D6uWPi5LgrENocb2Pi2XVe-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/3nVmZz9czgqfsTaiVcckPo-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/Ky9BAKiNttY3boEMxKc7h9-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/D7SearTTpbkg4CAPNq4Eu-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/68LieGcsa79WLYR2FarMT5-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/MkaZNqwgZJDMZsn86XQMJP-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/V5dyJcfDvCa49FcfcRQHDQ-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/ZnNHfWToWuQwJUKGPY9TTM-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/76ZSteou6SWJSm2Hdx54ZP-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/GgsagXJu9P84Qi8XY9JfZX-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/pAA8VCz2jqCCHHQvrvMbCC-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/cY2HLSvdZb2vgLt54ErT4Y-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/TMesgwHNt4rn6NWzsFtsiM-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/3nVmZz9czgqfsTaiVcckPo-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/PW88HdsDp7NdDvrAYwvRfU-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/N4YjTWMJdQRH9HFzyEaSc8-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/b75DC2xDhL9TjgG3fZrjzX-320-80.jpg',
                'https://cdn.mos.cms.futurecdn.net/FbyVKgVCTVL7wzZoXzpVqh-320-80.jpg'
            ]
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
                this.$toasted.show(
                    `You are a perfect match! Here's the contact for you: ${resp
                        .getContact()
                        .getText()}. Good luck!`
                );
            } else {
                this.$toasted.show(
                    `You are not a match! Your distance is ${resp.getDistance()} :(`
                );
            }
        }
    }
};
</script>
