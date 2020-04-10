import Vue from 'vue';
import VueRouter from 'vue-router';
import Index from '@/views/Index';
import Login from '@/views/Login';
import Register from '@/views/Register';
import Public from '@/views/Public';
import Friends from "@/views/Friends";
import Crashes from "@/views/Crashes";

Vue.use(VueRouter);

const routes = [
    {
        path: '/',
        name: 'Index',
        component: Index
    },
    {
        path: '/login',
        name: 'Login',
        component: Login,
    },
    {
        path: '/register',
        name: 'Register',
        component: Register,
    },
    {
        path: '/public',
        name: 'Public',
        component: Public,
    },
    {
        path: '/friends',
        name: 'Friends',
        component: Friends,
    },
    {
        path: '/crashes',
        name: 'Crashes',
        component: Crashes,
    }
];

const router = new VueRouter({
    mode: 'history',
    base: process.env.BASE_URL,
    routes
});

export default router;
