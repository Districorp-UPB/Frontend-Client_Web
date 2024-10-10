const iPv4 =
    "http://sistema3.bucaramanga.upb.edu.co:4000"; //IP de la máquina donde está corriendo el CCA del web server

// Urls de login y registro
const loginUrl = "$iPv4/api/authenticate";
const registerUserUrl = "$iPv4/api/register";
// const imagenesGetUrl = "http://localhost:4000/api/fileserver/imagenes/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Mjg0ODY3MDUsImV4cCI6MTcyODU3MzEwNSwiZW1haWwiOiJqb2huLmRvZUBkaXN0cmljb3JwLmNvbSJ9.eadYXyK7xdtY_3qQIXjU1Tj6ixkZh7-iKMZYN36lHYQ";

// Urls de actulizar
const actualizarUserUrl = "$iPv4/api/edit";
const actualizarProfileUrl = "$iPv4/api/editme";

//Urls de obtener usuarios
const obtenerUserUrl = "$iPv4/api/list";
const obtenerDatosPersonalesUrl = "$iPv4/api/usuario";

//Urls de delete usuarios
const eliminarUserUrl = "$iPv4/api/delete";
