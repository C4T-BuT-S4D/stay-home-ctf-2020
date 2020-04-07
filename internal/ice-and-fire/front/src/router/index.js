import Vue from 'vue';
import VueRouter from 'vue-router';
import Index from '@/views/Index';
import Register from '@/views/Register';
import Login from '@/views/Login';
import Users from '@/views/Users';

Vue.use(VueRouter);

const routes = [
    {
        path: '/',
        name: 'Index',
        component: Index
    },
    {
        path: '/register',
        name: 'Register',
        component: Register
    },
    {
        path: '/login',
        name: 'Login',
        component: Login
    },
    {
        path: '/users',
        name: 'Users',
        component: Users
    }
];

const router = new VueRouter({
    mode: 'history',
    base: process.env.BASE_URL,
    routes
});

export default router;
