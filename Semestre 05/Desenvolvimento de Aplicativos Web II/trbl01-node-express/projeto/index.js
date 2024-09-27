// Ex. 01 - Importa o express
const express = require('express');
const app = express();

// Ex. 05 - Configuração para interpretar o JSON
app.use(express.json());

 // Ex. 04 - Lista de produtos
 const produtos = [
    { id: 1, nome: 'Notebook', preco: 2500 },
    { id: 2, nome: 'Smartphone', preco: 1500 },
    { id: 3, nome: 'Tablet', preco: 1200 },
    { id: 4, nome: 'Monitor', preco: 800 },
    { id: 5, nome: 'Teclado', preco: 100 }
  ];

// Define a porta onde o servidor vai rodar
const port = 3000;

// Configura uma rota GET para a raiz do projeto
app.get('/', (req, res) => {
  res.send('Bem-vindo ao meu primeiro projeto com Express.js!');
});

// Inicia o servidor e escuta na porta configurada
app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});

// Ex. 02 - Rota dinâmica que recebe o nome do usuário
app.get('/saudacao/:nome', (req, res) => {
    const nomeUsuario = req.params.nome;
    res.send(`Olá, ${nomeUsuario}!`);
  });
  
// Ex. 03 - Middleware de autenticação fake
const autenticacaoFake = (req, res, next) => {
    const token = req.headers['authorization']; // Verifica o cabeçalho 'authorization'
  
    if (token) {
      console.log('Token recebido:', token);
      next(); // Se o token estiver presente, continue para a próxima rota
    } else {
      res.status(401).send('Erro 401: Não Autorizado - Token ausente'); // Se não houver token, retorne 401
    }
  };

  // Ex. 03 - Rota protegida com middleware de autenticação
app.get('/protegida', autenticacaoFake, (req, res) => {
    res.send('Você acessou uma rota protegida!');
  });

  // Ex. 04 - Rota GET para filtrar produtos por query params
app.get('/produtos', (req, res) => {
    const { nome, precoMax } = req.query;
  
    // Filtra a lista de produtos com base nos parâmetros
    let produtosFiltrados = produtos;
  
    if (nome) {
      produtosFiltrados = produtosFiltrados.filter(produto =>
        produto.nome.toLowerCase().includes(nome.toLowerCase())
      );
    }
  
    if (precoMax) {
      produtosFiltrados = produtosFiltrados.filter(produto =>
        produto.preco <= parseFloat(precoMax)
      );
    }
  
    // Retorna a lista filtrada
    res.json(produtosFiltrados);
  });
  
    // Ex. 06 - Middleware para validação de dados
  function validarProduto(req, res, next) {
      const { nome, preco } = req.body;
    
      // Verifica se o campo "nome" está presente e não está vazio
      if (nome == null || typeof nome !== 'string' || nome.trim().length === 0) {
        return res.status(400).json({ erro: 'O campo "nome" é obrigatório e deve ser uma string.' });
      }
    
      // Verifica se o campo "preco" está presente e é um número positivo
      if (preco == null || typeof preco !== 'number' || preco <= 0) {
        return res.status(400).json({ erro: 'O campo "preço" é obrigatório e deve ser um número positivo.' });
      }
    
      // Se os dados forem válidos, chama o próximo middleware ou rota
      next();
    }
  
  // Ex. 05 e 06 - Rota POST para adicionar um novo produto com validação
app.post('/produtos', validarProduto, (req, res) => {
    const novoProduto = req.body;    // Obtém o objeto JSON enviado no corpo da requisição
  
    // Ex. 06 - Cria um ID único para o novo produto
    const novoId = produtos.length + 1;
    const produtoComId = { id: novoId, ...novoProduto };
  
    // Ex. 06 - Adiciona o novo produto à lista de produtos
    produtos.push(produtoComId);
  
    // Ex. 06 - Retorna o produto com o novo ID
    res.status(201).json(produtoComId);
  });

  // Ex. 07 - Middleware de tratamento de erros global
app.use((err, req, res, next) => {
  console.error(err.stack); // Loga o erro para depuração

  // Ex. 07 - Retorna uma resposta JSON com o status de erro e mensagem
  res.status(err.status || 500).json({
    erro: {
      mensagem: err.message || 'Erro interno no servidor',
      status: err.status || 500,
    },
  });
});

// Ex. 07 - Rota que sempre lança um erro
app.get('/erro', (req, res, next) => {
  const erro = new Error('Algo deu errado!');
  erro.status = 400; // Define o status do erro (por exemplo, 400 - Bad Request)
  next(erro); // Passa o erro para o middleware de tratamento de erros
}); 

// Ex. 07 - Rota que gera um erro 500 (Erro Interno)
app.get('/erro-interno', (req, res, next) => {
  next(new Error('Erro interno no servidor'));
});



  
  
 
  
  
  