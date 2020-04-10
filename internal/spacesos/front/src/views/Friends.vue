<template>
    <layout>
        <div class="row">
            <div class="twelve columns text-center"><br/>
                <h5 style="color: white;">Your friends:</h5>
                    <li v-for="friend in friends" :key="friend" style="color: white">
                        {{ friend }}
                    </li>
            </div>
        </div>

        <div class="row">
            <div class="twelve columns text-center"><br/>
                <h5 style="color: white;">Incoming friendship requests:</h5>
                <li v-for="user in requests" :key="user" style="color: white">
                    {{ user }} want be your friend; <a href="#" v-on:click="addToFriends(user)">Accept</a>
                </li>

            </div>
        </div>

        <div class="twelve columns text-center"><br/>
            <h3 style="color: white;">Send friendship request</h3>
            <form @submit="addToFriends(name)">
                <label style="color: white;">Username:
                    <input required v-model="name" type="text" style="width: 30%; margin-left: 35%" placeholder="admin">
                </label>
                <button class="button success" type="submit">Login</button>
            </form>
        </div>
    </layout>
</template>
<script>
    import Layout from './Layout';
    import {AddToFriendRequest, FriendshipRequestsRequest, FriendsRequest} from '@/spacesos_pb.js';

    export default {
        data: function () {
            return {
                requests: [],
                friends: [],
                name: '',
            };
        },
        components: {
            Layout
        },
        methods: {
            async getFriendshipRequests() {
                try {
                    let req = new FriendshipRequestsRequest();
                    req.setSessionid(this.$store.state.sessionId);
                    let resp = await this.$client.friendshipRequests(req, {});
                    this.requests = resp.getUsersList();
                } catch (e) {
                    this.$toasted.error(e.message);
                }
            },
            async getFriends() {
                try {
                    let req = new FriendsRequest();
                    req.setSessionid(this.$store.state.sessionId);
                    let resp = await this.$client.getFriends(req, {});
                    this.friends = resp.getUsersList();
                } catch (e) {
                    this.$toasted.error(e.message);
                }
            },
            async addToFriends(name) {
                try {
                    let req = new AddToFriendRequest();
                    req.setSessionid(this.$store.state.sessionId);
                    req.setUsername(name);
                    await this.$client.addToFriend(req, {});
                } catch (e) {
                    this.$toasted.error(e.message);
                }
            }

        },
        async mounted() {
            await this.getFriends();
            await this.getFriendshipRequests();
        }
    };
</script>
