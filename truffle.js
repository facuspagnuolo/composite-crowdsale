require('babel-register');
require('babel-polyfill');
module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      network_id: '*',
    },
    testrpc: {
      host: 'localhost',
      port: 8545,
      network_id: '*',
    },
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
};
