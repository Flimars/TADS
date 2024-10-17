Aqui está uma estrutura básica para um CRUD com Node.js, Express e SQLite3 usando o padrão MVC e as regras de negócio mencionadas. O projeto terá autenticação, autorização, validação, tratamento de erros, e logs, além de tratar todas as operações de cadastro de usuários com múltiplos telefones e e-mails.

### Estrutura do Projeto:

```
/myapp
|-- /controllers
|-- /models
|-- /views
|-- /routes
|-- /database
|-- /middleware
|-- /logs
|-- app.js
```

### 1. **Setup do Projeto**
No terminal:
```bash
mkdir myapp
cd myapp
npm init -y
npm install express sqlite3 bcryptjs jsonwebtoken body-parser winston express-validator
```

### 2. **Banco de Dados com SQLite3**

**database/db.js**
```javascript
const sqlite3 = require('sqlite3').verbose();

const db = new sqlite3.Database('./database/users.db', (err) => {
    if (err) {
        console.error("Erro ao conectar no banco de dados:", err.message);
    } else {
        console.log("Conectado ao banco de dados SQLite.");
    }
});

// Criação das tabelas (usuários, emails, telefones)
db.serialize(() => {
    db.run(`
        CREATE TABLE IF NOT EXISTS usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            cpf TEXT UNIQUE NOT NULL,
            senha TEXT NOT NULL,
            perfil TEXT DEFAULT 'CLIENTE' CHECK(perfil IN ('ADMIN', 'CLIENTE')),
            PRIMARY KEY(id)
        )
    `);

    db.run(`
        CREATE TABLE IF NOT EXISTS emails (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id INTEGER,
            email TEXT NOT NULL,
            principal INTEGER DEFAULT 0,
            FOREIGN KEY(usuario_id) REFERENCES usuarios(id)
        )
    `);

    db.run(`
        CREATE TABLE IF NOT EXISTS telefones (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id INTEGER,
            telefone TEXT NOT NULL,
            principal INTEGER DEFAULT 0,
            FOREIGN KEY(usuario_id) REFERENCES usuarios(id)
        )
    `);
});

module.exports = db;
```

### 3. **Modelos**

**models/User.js**
```javascript
const db = require('../database/db');

class User {
    static create({ nome, cpf, senha, perfil }, callback) {
        const query = `INSERT INTO usuarios (nome, cpf, senha, perfil) VALUES (?, ?, ?, ?)`;
        db.run(query, [nome, cpf, senha, perfil], function(err) {
            if (err) {
                return callback(err);
            }
            callback(null, { id: this.lastID });
        });
    }

    static findById(id, callback) {
        const query = `
        SELECT usuarios.*, telefones.telefone, emails.email 
        FROM usuarios 
        LEFT JOIN telefones ON usuarios.id = telefones.usuario_id 
        LEFT JOIN emails ON usuarios.id = emails.usuario_id 
        WHERE usuarios.id = ?`;
        db.all(query, [id], callback);
    }

    static update(id, { nome }, callback) {
        const query = `UPDATE usuarios SET nome = ? WHERE id = ?`;
        db.run(query, [nome, id], callback);
    }

    static delete(id, callback) {
        const query = `DELETE FROM usuarios WHERE id = ? AND perfil != 'ADMIN'`;
        db.run(query, [id], callback);
    }

    static paginate(page, filter, callback) {
        const limit = 5;
        const offset = (page - 1) * limit;
        const query = `
        SELECT * FROM usuarios 
        WHERE nome LIKE ? 
        LIMIT ? OFFSET ?`;
        db.all(query, [`%${filter}%`, limit, offset], callback);
    }
}

module.exports = User;
```

**models/Email.js**
```javascript
const db = require('../database/db');

class Email {
    static addEmail(usuario_id, email, principal, callback) {
        const query = `INSERT INTO emails (usuario_id, email, principal) VALUES (?, ?, ?)`;
        db.run(query, [usuario_id, email, principal], callback);
    }

    static updatePrincipal(usuario_id, id, callback) {
        db.run(`UPDATE emails SET principal = 0 WHERE usuario_id = ?`, [usuario_id], (err) => {
            if (err) return callback(err);
            db.run(`UPDATE emails SET principal = 1 WHERE id = ?`, [id], callback);
        });
    }
}

module.exports = Email;
```

**models/Phone.js**
```javascript
const db = require('../database/db');

class Phone {
    static addPhone(usuario_id, telefone, principal, callback) {
        const query = `INSERT INTO telefones (usuario_id, telefone, principal) VALUES (?, ?, ?)`;
        db.run(query, [usuario_id, telefone, principal], callback);
    }

    static updatePrincipal(usuario_id, id, callback) {
        db.run(`UPDATE telefones SET principal = 0 WHERE usuario_id = ?`, [usuario_id], (err) => {
            if (err) return callback(err);
            db.run(`UPDATE telefones SET principal = 1 WHERE id = ?`, [id], callback);
        });
    }
}

module.exports = Phone;
```

### 4. **Controladores**

**controllers/userController.js**
```javascript
const User = require('../models/User');
const bcrypt = require('bcryptjs');
const { validationResult } = require('express-validator');

// Criação de usuário
exports.createUser = (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const { nome, cpf, senha, perfil } = req.body;
    const hash = bcrypt.hashSync(senha, 8);

    User.create({ nome, cpf, senha: hash, perfil }, (err, user) => {
        if (err) {
            return res.status(500).json({ message: "Erro ao criar usuário", error: err });
        }
        res.status(201).json({ message: "Usuário criado com sucesso", user });
    });
};

// Atualização de usuário (exceto perfil e CPF)
exports.updateUser = (req, res) => {
    const { nome } = req.body;
    const { id } = req.params;

    User.update(id, { nome }, (err) => {
        if (err) {
            return res.status(500).json({ message: "Erro ao atualizar usuário", error: err });
        }
        res.status(200).json({ message: "Usuário atualizado com sucesso" });
    });
};

// Paginação e filtro
exports.getUsers = (req, res) => {
    const { page = 1, filter = '' } = req.query;

    User.paginate(page, filter, (err, users) => {
        if (err) {
            return res.status(500).json({ message: "Erro ao buscar usuários", error: err });
        }
        res.status(200).json(users);
    });
};

// Detalhes do usuário
exports.getUserDetails = (req, res) => {
    const { id } = req.params;

    User.findById(id, (err, user) => {
        if (err) {
            return res.status(500).json({ message: "Erro ao buscar detalhes do usuário", error: err });
        }
        res.status(200).json(user);
    });
};

// Exclusão de usuário (não pode remover ADMIN)
exports.deleteUser = (req, res) => {
    const { id } = req.params;

    User.delete(id, (err) => {
        if (err) {
            return res.status(500).json({ message: "Erro ao excluir usuário", error: err });
        }
        res.status(200).json({ message: "Usuário excluído com sucesso" });
    });
};
```

### 5. **Rotas**

**routes/userRoutes.js**
```javascript
const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const { body } = require('express-validator');

// Rota para criação de usuários
router.post(
    '/usuarios',
    [
        body('nome').notEmpty().withMessage('Nome é obrigatório'),
        body('cpf').isLength({ min: 11, max: 11 }).withMessage('CPF inválido'),
        body('senha').isLength({ min: 6 }).withMessage('Senha deve ter no mínimo 6 caracteres'),
        body('perfil').isIn(['ADMIN', 'CLIENTE']).withMessage('Perfil inválido')
    ],
    userController.createUser
);

// Rota para atualização de usuários
router.put('/usuarios/:id', userController.updateUser);

// Rota para obtenção de usuários com paginação e filtro
router.get('/usuarios', userController.getUsers);

// Rota para obtenção de detalhes de um usuário
router.get('/usuarios/:id', userController.getUserDetails);

// Rota para exclusão de usuários
router.delete('/usuarios/:id', userController.deleteUser);

module.exports = router;
```

### 6. **Middlewares de Autenticação e Autorização**

**middleware/auth.js**
```javascript
const jwt = require('jsonwebtoken');

// Autenticação
exports.authenticate = (req, res, next) => {
    const token = req.headers['authorization'];
    if (!token) {
        return res.status(401).json({ message: 'Token não fornecido' });
    }

    jwt.verify(token, 'segredo_super_secreto', (err, decoded) => {
        if (err) {
            return res.status(401).json({ message:

 'Token inválido' });
        }
        req.user = decoded;
        next();
    });
};

// Autorização (somente ADMIN)
exports.isAdmin = (req, res, next) => {
    if (req.user.perfil !== 'ADMIN') {
        return res.status(403).json({ message: 'Acesso negado. Somente administradores podem realizar esta ação.' });
    }
    next();
};
```

### 7. **Logs**

**middleware/logger.js**
```javascript
const winston = require('winston');

const logger = winston.createLogger({
    level: 'info',
    format: winston.format.json(),
    transports: [
        new winston.transports.File({ filename: './logs/error.log', level: 'error' }),
        new winston.transports.File({ filename: './logs/combined.log' }),
    ],
});

module.exports = logger;
```

### 8. **Inicializando o Servidor**

**app.js**
```javascript
const express = require('express');
const bodyParser = require('body-parser');
const userRoutes = require('./routes/userRoutes');
const logger = require('./middleware/logger');

const app = express();

app.use(bodyParser.json());
app.use((req, res, next) => {
    logger.info(`${req.method} ${req.url}`);
    next();
});

// Rotas de Usuário
app.use('/api', userRoutes);

app.listen(3000, () => {
    console.log('Servidor rodando na porta 3000');
});
```

### 9. **Conclusão**

Este código cobre as funcionalidades básicas de um sistema de cadastro de usuários com regras de negócio, incluindo criação, atualização, deleção (exceto admins), paginação, filtro, e tratamento de múltiplos emails e telefones.