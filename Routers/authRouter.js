const express = require('express');
const router = express.Router();
const authController = require('../Controllers/authController');



router.get('/users/user/:id', authController.getUserById); 
router.post('/signup', authController.signup);
router.post('/login', authController.login);
router.get('/users', authController.getUsers);
router.get('/users/clients', authController.getClientUsers);
router.get('/users/technicians', authController.getTechnicianUsers);
router.get('/users/chief', authController.getChiefUsers);
router.get('/search', authController.findUser); 
router.get('/search-Tech', authController.searchTechs);
router.get('/search-Clients', authController.searchClients);
router.get('/Blacklist', authController.getBlacklist);
router.put('/unban/:id', authController.unbanUser);
router.put('/users/:id', authController.updateUser);
router.delete('/users/:id', authController.deleteUser); 
router.post('/ban/:id', authController.banUser);

///image test
router.get('/test/users/chief', authController.getChiefUserstest);
router.get('/test/users/tech', authController.getTechnicianUserstest);
router.get('/test/users', authController.getUserstest);
router.get('/test/users/clients', authController.getClientUserstest);


module.exports = router;