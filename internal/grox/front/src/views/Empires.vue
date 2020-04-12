<template>
    <v-col cols="12" md="12">
        <v-simple-table v-if="error === null">
            <template v-slot:default>
                <thead>
                    <tr>
                        <th class="text-left">Name</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="empire of empires" :key="empire">
                        <td @click="openEmpire(empire)" class="pc">
                            {{ empire }}
                        </td>
                    </tr>
                </tbody>
            </template>
        </v-simple-table>
        <div class="red" v-if="error !== null" style="white-space: pre;">
            {{ error }}
        </div>
    </v-col>
</template>

<script>
import { isNull } from '@/utils/types';
import { mapState } from 'vuex';

export default {
    data: function() {
        return {
            empires: [],
            error: null
        };
    },

    computed: mapState(['user']),

    created: async function() {
        await this.fetchEmpires();
    },

    methods: {
        fetchEmpires: async function() {
            const uid = this.$route.params.id;
            const r = await this.$http.get(`/user/${uid}/empires`);
            try {
                this.empires = r.data.ok;
            } catch (_) {
                this.error = r.data.error;
            }
        },
        isNull,
        openEmpire: function(empire) {
            this.$router.push({ name: 'empire', params: { id: empire } });
        }
    },

    watch: {
        $route: async function() {
            await this.fetchEmpires();
        }
    }
};
</script>

<style lang="scss" scoped>
.pc {
    cursor: pointer;
}
</style>
