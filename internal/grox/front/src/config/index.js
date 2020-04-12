let url = '';

if (process.env.NODE_ENV === 'development') {
    url = 'http://127.0.0.1:9613';
} else {
    url = window.location.origin;
}

const serverUrl = url;

const apiUrl = `${serverUrl}/api`;

export { apiUrl };
