const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const mysql = require('mysql2');

// Create connection to the database
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'water company'
});

// Create connection to the database
// const connection = mysql.createConnection({
//   host: 'mysql-service',
//   user: 'root',
//   password: 'root123',
//   database: 'water company'
// });

// Create connection to the database
// const connection = mysql.createConnection({
//   host: 'db',
//   user: 'root',
//   password: '',
//   database: 'water_company'
// });

// Connect to the database
connection.connect(err => {
  if (err) {
    console.error('Error connecting to the database:', err);
    return;
  }
  console.log('Connected to the database');
});

//listing the users api
exports.getUsers = async (req, res) => {
  try {
    const token = req.headers.authorization;
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    jwt.verify(token, 'your_secret_key_here', async (err, decoded) => {
      if (err) {
        return res.status(401).json({ error: 'Invalid token' });
      }

      connection.query('SELECT users.*, Teams.name AS team_name FROM users INNER JOIN Teams ON users.teamId = Teams.id', (err, rows) => {
        if (err) {
          console.error('Error retrieving users:', err);
          return res.status(500).json({ error: 'An error occurred while retrieving users' });
        }
        res.status(200).json(rows);
      });
    });
  } catch (error) {
    console.error('Error retrieving users:', error);
    res.status(500).json({ error: 'An error occurred while retrieving users' });
  }
};

//get Clients
exports.getClientUsers = async (req, res) => {
  try {
    const token = req.headers.authorization;
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    jwt.verify(token, 'your_secret_key_here', async (err, decoded) => {
      if (err) {
        return res.status(401).json({ error: 'Invalid token' });
      }
      
      connection.query('SELECT * FROM users WHERE userType = "client" AND isBanned = 0', (err, rows) => {
        if (err) {
          console.error('Error retrieving client users:', err);
          return res.status(500).json({ error: 'An error occurred while retrieving client users' });
        }
        res.status(200).json(rows);
      });
    });
  } catch (error) {
    console.error('Error retrieving client users:', error);
    res.status(500).json({ error: 'An error occurred while retrieving client users' });
  }
};

// Listing the technician users
exports.getTechnicianUsers = async (req, res) => {
  try {
    const token = req.headers.authorization;
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    jwt.verify(token, 'your_secret_key_here', async (err, decoded) => {
      if (err) {
        return res.status(401).json({ error: 'Invalid token' });
      }
      
      connection.query('SELECT * FROM users WHERE userType = "technician"', (err, rows) => {
        if (err) {
          console.error('Error retrieving technician users:', err);
          return res.status(500).json({ error: 'An error occurred while retrieving technician users' });
        }
        res.status(200).json(rows);
      });
    });
  } catch (error) {
    console.error('Error retrieving technician users:', error);
    res.status(500).json({ error: 'An error occurred while retrieving technician users' });
  }
};

// Listing the chief users
exports.getChiefUsers = async (req, res) => {
  try {
    const token = req.headers.authorization;
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    jwt.verify(token, 'your_secret_key_here', async (err, decoded) => {
      if (err) {
        return res.status(401).json({ error: 'Invalid token' });
      }
      
      connection.query('SELECT * FROM users WHERE userType = "chief"', (err, rows) => {
        if (err) {
          console.error('Error retrieving chief users:', err);
          return res.status(500).json({ error: 'An error occurred while retrieving chief users' });
        }
        res.status(200).json(rows);
      });
    });
  } catch (error) {
    console.error('Error retrieving chief users:', error);
    res.status(500).json({ error: 'An error occurred while retrieving chief users' });
  }
};

// Sign up api
exports.signup = async (req, res) => {
  try {
    const { username, email, password, location, userType, tel, cin } = req.body;

    // Check if user with the same email, tel, or cin is banned
    connection.query('SELECT * FROM users WHERE email = ? OR tel = ? OR cin = ?', [email, tel, cin], (err, rows) => {
      if (err) {
        console.error('Error checking banned identifiers:', err);
        return res.status(500).json({ error: 'An error occurred while checking banned identifiers' });
      }

      if (rows.length > 0 && rows[0].isBanned === 1) {
        return res.status(403).json({ error: 'You are banned from creating a new account' });
      }

      // Hash the password
      bcrypt.hash(password, 10, (err, hashedPassword) => {
        if (err) {
          console.error('Error hashing password:', err);
          return res.status(500).json({ error: 'An error occurred while hashing password' });
        }

        // Create new user
        connection.query('INSERT INTO users SET ?', { username, email, password: hashedPassword, location, userType, tel, cin, isBanned: 0 }, (err, result) => {
          if (err) {
            console.error('Error creating user:', err);
            return res.status(500).json({ error: 'An error occurred while creating user' });
          }
          res.status(201).json({ message: 'User signed up successfully', userId: result.insertId });
        });
      });
    });
  } catch (error) {
    console.error('Error signing up user:', error);
    res.status(500).json({ error: 'An error occurred while signing up user' });
  }
};



// Login API
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find user by email
    connection.query('SELECT * FROM users WHERE email = ?', [email], (err, rows) => {
      if (err) {
        console.error('Error finding user:', err);
        return res.status(500).json({ error: 'An error occurred while finding user' });
      }

      if (rows.length === 0) {
        return res.status(401).json({ error: 'Invalid email or password' });
      }

      const user = rows[0];

      // Check if user is banned
      if (user.isBanned === 1) {
        return res.status(403).json({ error: 'Your account has been banned. Please contact support for assistance.' });
      }

      // Compare passwords
      bcrypt.compare(password, user.password, (err, isPasswordValid) => {
        if (err) {
          console.error('Error comparing passwords:', err);
          return res.status(500).json({ error: 'An error occurred while comparing passwords' });
        }

        if (!isPasswordValid) {
          return res.status(401).json({ error: 'Invalid email or password' });
        }

        // Generate JWT token with user's role included
        const token = jwt.sign({ userId: user.id, username: user.username, userType: user.userType, location: user.location }, 'your_secret_key_here');

        res.status(200).json({ token });
      });
    });
  } catch (error) {
    console.error('Error logging in user:', error);
    res.status(500).json({ error: 'An error occurred while logging in user' });
  }
};


//search api
exports.findUser = async (req, res) => {
  try {
    const { username, tel, location, userType } = req.query;
    const searchParams = {};

    if (username) {
      searchParams.username = `%${username}%`;
    }
    if (tel) {
      searchParams.tel = `%${tel}%`;
    }
    if (location) {
      searchParams.location = `%${location}%`;
    }
    if (userType) {
      searchParams.userType = `%${userType}%`;
    }

    connection.query('SELECT * FROM users WHERE ?', [searchParams], (err, rows) => {
      if (err) {
        console.error('Error searching users:', err);
        return res.status(500).json({ error: 'An error occurred while searching users' });
      }

      if (rows.length === 0) {
        return res.status(404).json({ message: "No users found." });
      }

      return res.status(200).json(rows);
    });
  } catch (error) {
    console.error('Error searching users:', error);
    res.status(500).json({ error: 'An error occurred while searching users' });
  }
};

// Update User
exports.updateUser = async (req, res) => {
  try {
    const token = req.headers.authorization;
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    jwt.verify(token, 'your_secret_key_here', async (err, decoded) => {
      if (err) {
        return res.status(401).json({ error: 'Invalid token' });
      }

      const { id } = req.params;
      const { username, email, location, tel, cin } = req.body;

      connection.query('UPDATE users SET username = ?, email = ?, location = ?, tel = ?, cin = ? WHERE id = ?', [username, email, location, tel, cin, id], (err, result) => {
        if (err) {
          console.error('Error updating user:', err);
          return res.status(500).json({ error: 'An error occurred while updating user' });
        }

        res.status(200).json({ message: 'User updated successfully' });
      });
    });
  } catch (error) {
    console.error('Error updating user:', error);
    res.status(500).json({ error: 'An error occurred while updating user' });
  }
};

// Delete User
exports.deleteUser = async (req, res) => {
  try {
    const token = req.headers.authorization;
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    jwt.verify(token, 'your_secret_key_here', async (err, decoded) => {
      if (err) {
        return res.status(401).json({ error: 'Invalid token' });
      }

      const { id } = req.params;

      connection.query('DELETE FROM users WHERE id = ?', [id], (err, result) => {
        if (err) {
          console.error('Error deleting user:', err);
          return res.status(500).json({ error: 'An error occurred while deleting user' });
        }

        res.status(200).json({ message: 'User deleted successfully' });
      });
    });
  } catch (error) {
    console.error('Error deleting user:', error);
    res.status(500).json({ error: 'An error occurred while deleting user' });
  }
};

//search techniciens
exports.searchTechs = async (req, res) => {
  try {
    const token = req.headers.authorization;
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    jwt.verify(token, 'your_secret_key_here', async (err, decoded) => {
      if (err) {
        return res.status(401).json({ error: 'Invalid token' });
      }

      const { query, username, location, tel, cin } = req.query;

      let queryStr = 'SELECT * FROM users WHERE userType = "technician"';
      let params = [];

      if (query || username || tel || cin) {
        queryStr += ' AND (username LIKE ? OR tel LIKE ? OR cin LIKE ?)';
        params.push(`%${query || username || tel || cin}%`);
        params.push(`%${query || username || tel || cin}%`);
        params.push(`%${query || username || tel || cin}%`);
      }
      if (location) {
        queryStr += ' AND location LIKE ?';
        params.push(`%${location}%`);
      }

      connection.query(queryStr, params, (err, rows) => {
        if (err) {
          console.error('Error searching clients:', err);
          return res.status(500).json({ error: 'An error occurred while searching clients' });
        }

        if (rows.length === 0) {
          return res.status(200).json({ message: "No technicians found.", rows: [] }); // Return an empty result with a message
        }

        return res.status(200).json({ message: "technicians found.", rows });
      });
    });
  } catch (error) {
    console.error('Error searching technicians:', error);
    res.status(500).json({ error: 'An error occurred while searching technicians' });
  }
};


//search Clients
exports.searchClients = async (req, res) => {
  try {
    const token = req.headers.authorization;
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    jwt.verify(token, 'your_secret_key_here', async (err, decoded) => {
      if (err) {
        return res.status(401).json({ error: 'Invalid token' });
      }

      const { query, username, location, tel, cin } = req.query;

      let queryStr = "SELECT * FROM users WHERE userType = 'client' AND isBanned = 0";
      let params = [];

      if (query || username || tel || cin) {
        queryStr += ' AND (username LIKE ? OR tel LIKE ? OR cin LIKE ?)';
        params.push(`%${query || username || tel || cin}%`);
        params.push(`%${query || username || tel || cin}%`);
        params.push(`%${query || username || tel || cin}%`);
      }
      if (location) {
        queryStr += ' AND location LIKE ?';
        params.push(`%${location}%`);
      }

      connection.query(queryStr, params, (err, rows) => {
        if (err) {
          console.error('Error searching clients:', err);
          return res.status(500).json({ error: 'An error occurred while searching clients' });
        }

        if (rows.length === 0) {
          return res.status(200).json({ message: "No client found.", rows: [] }); // Return an empty result with a message
        }

        return res.status(200).json({ message: "client found.", rows });
      });
    });
  } catch (error) {
    console.error('Error searching technicians:', error);
    res.status(500).json({ error: 'An error occurred while searching technicians' });
  }
};

// Get user By id 
exports.getUserById = async (req, res) => {
  try {
    const token = req.headers.authorization;
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    jwt.verify(token, 'your_secret_key_here', async (err, decoded) => {
      if (err) {
        if (err.name === 'JsonWebTokenError') {
          return res.status(401).json({ error: 'Invalid token' });
        } else {
          return res.status(500).json({ error: 'An error occurred while verifying token' });
        }
      }

      const { id } = req.params;

      connection.query('SELECT * FROM users WHERE id = ?', [id], (err, rows) => {
        if (err) {
          console.error('Error fetching user by ID:', err);
          return res.status(500).json({ error: 'An error occurred while fetching user by ID' });
        }

        if (rows.length === 0) {
          return res.status(404).json({ error: 'User not found' });
        }

        const user = rows[0];

        // Set the user in the request object
        req.user = user;

        // Send the user back in the response
        res.status(200).json(user);
      });
    });
  } catch (error) {
    console.error('Error fetching user by ID:', error);
    res.status(500).json({ error: 'An error occurred while fetching user by ID' });
  }
};

// Ban User
exports.banUser = async (req, res) => {
  try {
    const token = req.headers.authorization;
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    jwt.verify(token, 'your_secret_key_here', async (err, decoded) => {
      if (err) {
        return res.status(401).json({ error: 'Invalid token' });
      }

      const { id } = req.params;

      // Update user's isBanned flag to mark them as banned
      connection.query('UPDATE users SET isBanned = 1 WHERE id = ?', [id], (err, result) => {
        if (err) {
          console.error('Error banning user:', err);
          return res.status(500).json({ error: 'An error occurred while banning user' });
        }
        res.status(200).json({ message: 'User banned successfully' });
      });
    });
  } catch (error) {
    console.error('Error banning user:', error);
    res.status(500).json({ error: 'An error occurred while banning user' });
  }
};


exports.getBlacklist = async (req, res) => {
  try {
    const token = req.headers.authorization;
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    jwt.verify(token, 'your_secret_key_here', async (err, decoded) => {
      if (err) {
        return res.status(401).json({ error: 'Invalid token' });
      }

      connection.query('SELECT * FROM users WHERE isBanned = 1', (err, rows) => {
        if (err) {
          console.error('Error retrieving blacklist:', err);
          return res.status(500).json({ error: 'An error occurred while retrieving blacklist' });
        }

        return res.status(200).json(rows);
      });
    });
  } catch (error) {
    console.error('Error retrieving blacklist:', error);
    res.status(500).json({ error: 'An error occurred while retrieving blacklist' });
  }
};

// Unban a user function
exports.unbanUser = async (req, res) => {
  try {
    const token = req.headers.authorization;
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    jwt.verify(token, 'your_secret_key_here', async (err, decoded) => {
      if (err) {
        return res.status(401).json({ error: 'Invalid token' });
      }

      const { id } = req.params;

      connection.query('UPDATE users SET isBanned = 0 WHERE id = ?', [id], (err, result) => {
        if (err) {
          console.error('Error unbanning user:', err);
          return res.status(500).json({ error: 'An error occurred while unbanning user' });
        }

        return res.status(200).json({ message: 'User unbanned successfully' });
      });
    });
  } catch (error) {
    console.error('Error unbanning user:', error);
    res.status(500).json({ error: 'An error occurred while unbanning user' });
  }
};




//for the image testing


// get all users
exports.getUserstest = async (req, res) => {
  try {
    connection.query('SELECT * FROM users', (err, rows) => {
      if (err) {
        console.error('Error retrieving users:', err);
        return res.status(500).json({ error: 'An error occurred while retrieving users' });
      }
      res.status(200).json(rows);
    });
  } catch (error) {
    console.error('Error retrieving users:', error);
    res.status(500).json({ error: 'An error occurred while retrieving users' });
  }
};

// get client users
exports.getClientUserstest = async (req, res) => {
  try {
    connection.query('SELECT * FROM users WHERE userType = "client" AND isBanned = 0', (err, rows) => {
      if (err) {
        console.error('Error retrieving client users:', err);
        return res.status(500).json({ error: 'An error occurred while retrieving client users' });
      }
      res.status(200).json(rows);
    });
  } catch (error) {
    console.error('Error retrieving client users:', error);
    res.status(500).json({ error: 'An error occurred while retrieving client users' });
  }
};

// get technician users
exports.getTechnicianUserstest = async (req, res) => {
  try {
    connection.query('SELECT * FROM users WHERE userType = "technician"', (err, rows) => {
      if (err) {
        console.error('Error retrieving technician users:', err);
        return res.status(500).json({ error: 'An error occurred while retrieving technician users' });
      }
      res.status(200).json(rows);
    });
  } catch (error) {
    console.error('Error retrieving technician users:', error);
    res.status(500).json({ error: 'An error occurred while retrieving technician users' });
  }
};

// get chief users
exports.getChiefUserstest = async (req, res) => {
  try {
    connection.query('SELECT * FROM users WHERE userType = "chief"', (err, rows) => {
      if (err) {
        console.error('Error retrieving chief users:', err);
        return res.status(500).json({ error: 'An error occurred while retrieving chief users' });
      }
      res.status(200).json(rows);
    });
  } catch (error) {
    console.error('Error retrieving chief users:', error);
    res.status(500).json({ error: 'An error occurred while retrieving chief users' });
  }
};
