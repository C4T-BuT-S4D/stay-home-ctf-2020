<template>
    <layout>
        <b-row class="justify-content-center">
            <b-col class="col-10 justify-content-center">
                <b-form @submit="onSubmit">
                    <b-form-group
                        id="input-group-username"
                        label="Username:"
                        label-for="input-username"
                    >
                        <b-form-input
                            id="input-username"
                            v-model="username"
                            required
                            placeholder="Username"
                        ></b-form-input>
                    </b-form-group>
                    <b-form-group
                        id="input-group-password"
                        label="Password:"
                        label-for="input-password"
                    >
                        <b-form-input
                            id="input-password"
                            v-model="password"
                            required
                            placeholder="Password"
                        ></b-form-input>
                    </b-form-group>

                    <b-form-group
                        id="input-group-contact"
                        label="Contact:"
                        label-for="input-contact"
                    >
                        <b-form-input
                            id="input-contact"
                            v-model="contact"
                            required
                            placeholder="Contact"
                        ></b-form-input>
                    </b-form-group>

                    <b-form-group
                        :id="`input-group-coords-${i}`"
                        :label="names[i]"
                        :label-for="`input-coord-${names[i]}`"
                        v-for="(slider, i) of sliders"
                        v-bind:key="i"
                    >
                        <vue-slider
                            :id="`input-coord-${names[i]}`"
                            v-bind="sliders[i]"
                            v-model="coordinates[i]"
                        />
                    </b-form-group>

                    <b-button class="mx-auto" type="submit" variant="primary"
                        >Register</b-button
                    >
                </b-form>
            </b-col>
        </b-row>
    </layout>
</template>

<script>
import Layout from '@/layouts/Layout';
import { Response, RegisterRequest, User, Contact } from '@/proto/structs_pb';
import VueSlider from 'vue-slider-component';
import 'vue-slider-component/theme/antd.css';

export default {
    components: {
        Layout,
        VueSlider
    },
    data() {
        let sliders = [];
        let coords = [];
        for (let i = 0; i < 16; ++i) {
            sliders.push({ min: 0, max: 1000 });
            coords.push(0);
        }
        return {
            username: '',
            password: '',
            contact: '',
            coordinates: coords,
            sliders: sliders,
            names: [
                'Age',
                'Chemical composition',
                'Diameter',
                'Kinematics',
                'Magnetic field',
                'Mass',
                'Rotation',
                'Temperature',
                'Radiation',
                'Luminosity',
                'Magnitude',
                'Brightness',
                'Color',
                'Rings',
                'Spectral value',
                'Habitability'
            ]
        };
    },
    methods: {
        async onSubmit(evt) {
            evt.preventDefault();

            let user = new User();
            user.setUsername(this.username);
            user.setPassword(this.password);

            let contact = new Contact();
            contact.setText(this.contact);

            let regReq = new RegisterRequest();
            regReq.setUser(user);
            regReq.setContact(contact);
            regReq.setCoordinatesList(this.coordinates);
            let rawResp = null;
            try {
                rawResp = await this.$http.post(
                    '/register/',
                    regReq.serializeBinary(),
                    {
                        responseType: 'arraybuffer',
                        headers: { 'Content-Type': 'application/octet-stream' }
                    }
                );
            } catch (e) {
                rawResp = e.response;
            }
            let resp = Response.deserializeBinary(rawResp.data);
            let ok = resp.getOk();
            if (!ok) {
                this.$toasted.show(`Error: ${resp.getText()}`);
            } else {
                this.$router.push({ name: 'Login' });
            }
        }
    }
};
</script>
