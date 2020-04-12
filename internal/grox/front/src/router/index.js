import Vue from 'vue';
import VueRouter from 'vue-router';
import Users from '@/views/Users';
import Empires from '@/views/Empires';
import Empire from '@/views/Empire';
import CreateEmpire from '@/views/CreateEmpire';
import store from '@/store';
import { isNull } from '@/utils/types';

Vue.use(VueRouter);

const routes = [
    {
        path: '/',
        name: 'index',
        component: Users
    },
    {
        path: '/empires/:id',
        name: 'empires',
        component: Empires
    },
    {
        path: '/empire/:id',
        name: 'empire',
        component: Empire
    },
    {
        path: '/create/empire',
        name: 'create_empire',
        component: CreateEmpire,
        meta: {
            auth: true
        }
    }
];

const router = new VueRouter({
    mode: 'history',
    base: process.env.BASE_URL,
    routes
});

function dec2hex(dec) {
    return ('0' + dec.toString(16)).substr(-2);
}

function str2hex(str) {
    let res = '';
    for (let i = 0; i < str.length; i += 1) {
        res += dec2hex(str.charCodeAt(i));
    }
    return res;
}

router.beforeEach(async (to, from, next) => {
    const user = await store.dispatch('GET_USER');
    if (to.matched.some(record => record.meta.auth)) {
        if (isNull(user)) {
            next({
                name: 'index',
                query: {
                    redirect: str2hex(
                        JSON.stringify({
                            name: to.name,
                            query: to.query,
                            params: to.params
                        })
                    ),
                    logop: true
                }
            });
        } else {
            next();
        }
    } else {
        next();
    }
});

export default router;
