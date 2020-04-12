<template>
    <v-col cols="12" md="12">
        <d3-network
            :net-nodes="nodes"
            :net-links="links"
            :options="options"
            v-if="error === null"
            @node-click="getInfo"
        />
        <v-btn class="ml-3 mb-3" color="blue" @click="addPlanet"
            >Add planet</v-btn
        >
        <v-btn class="ml-3 mb-3" color="blue" @click="linkPlanets"
            >Link planets</v-btn
        >
        <div>
            <v-text-field v-model="l" label="l planet" required outlined />
            <v-text-field v-model="r" label="r planet" required outlined />
        </div>
        <div class="red" v-if="error !== null" style="white-space: pre;">
            {{ error }}
        </div>
    </v-col>
</template>

<script>
import { isNull } from '@/utils/types';
import { mapState } from 'vuex';
import D3Network from 'vue-d3-network';

export default {
    data: function() {
        return {
            name: null,
            nodes: [],
            links: [],
            error: null,
            cnt: 0,
            l: null,
            r: null,
            planets: [
                'Arkas',
                'Orbitar',
                'Taphao Thong',
                'Dimidium',
                'Galileo',
                'Amateru',
                'Dagon',
                'Tadmor',
                'Hypatia',
                'Quijote',
                'Thestias',
                'Saffar',
                'Fortitudo',
                'Draugr',
                'Eburonia',
                'Mastika',
                'Caleuche',
                'Ditsö̀',
                'Asye',
                'Finlay',
                'Toge',
                'Noifasui',
                'Lete',
                'Trimobe',
                'Xólotl',
                'Laligurans',
                'Perwana',
                'Tumearandu',
                'Leklsullun',
                'Negoiu',
                'Dopere',
                'Eiger',
                'Sazum',
                'Barajeel'
            ],
            options: {
                force: 3000,
                nodeSize: 20,
                nodeLabels: true,
                linkWidth: 5
            }
        };
    },

    components: {
        D3Network
    },

    computed: mapState(['user']),

    created: async function() {
        await this.fetchEmpire();
    },

    methods: {
        isNull,
        getInfo: async function(_, node) {
            const { id } = node;

            let r;

            try {
                r = await this.$http.get(`/planet/${id}`);
                const name = r.data.ok.name;
                const rname = name;
                const info = r.data.ok.info;
                this.nodes = this.nodes.map(({ id: idx, name }) => {
                    if (id === idx) {
                        return {
                            id,
                            name: `Name: ${rname}, Info: ${info}, Id: ${id}`,
                            _color: 'white'
                        };
                    }
                    return {
                        id: idx,
                        _color: 'white',
                        name
                    };
                });
                this.links = this.links.map(link => link);
            } catch (_) {
                console.error('forbidden');
            }
        },

        addPlanet: async function() {
            const graph = this.$route.params.id;
            try {
                await this.$http.post('/planet/create', {
                    graph: parseInt(graph, 10),
                    name: this.planets[this.cnt % this.planets.length],
                    info: 'It is a planet'
                });
                this.cnt += 1;
                await this.fetchEmpire();
            } catch (_) {
                console.error('forbidden');
            }
        },

        linkPlanets: async function() {
            try {
                await this.$http.post('/alliance/create', {
                    l: parseInt(this.l, 10),
                    r: parseInt(this.r, 10)
                });
                await this.fetchEmpire();
            } catch (_) {
                console.error('forbidden');
            }
        },

        getStr: function(idx) {
            let nds = this.nodes.filter(({ id }) => id === idx);
            if (nds.length > 0) {
                return nds[0].name;
            }
            return 'Unknown';
        },

        fetchEmpire: async function() {
            const id = this.$route.params.id;

            const r = await this.$http.get(`/empire/${id}`);

            try {
                const info = r.data.ok;
                this.name = info.name;
                this.nodes = info.nodes.map(id => ({
                    id,
                    _color: 'white',
                    name: this.getStr(id)
                }));
                this.links = info.links.map(([_, from, to]) => ({
                    sid: from,
                    tid: to,
                    _color: 'red'
                }));
            } catch (_) {
                this.error = r.data.error;
            }
        }
    }
};
</script>
