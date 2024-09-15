// MARK: Codable

import Foundation

struct Pessoa: Codable {
var nome: String
var idade: Int
var cidade: String
}

// MARK: Encode

let pessoa = Pessoa(nome: "João", idade: 28, cidade: "São Paulo")

if let jsonData = try? JSONEncoder().encode(pessoa),
   let jsonString = String(data: jsonData, encoding: .utf8) {
print(jsonString)

}

// MARK: Decode

let jsonData = """
{
"nome": "João",
"idade": 28,
"cidade": "São Paulo"
}
""".data(using: .utf8)!

if let pessoa = try? JSONDecoder().decode(Pessoa.self, from: jsonData) {
print(pessoa.nome)   // João
print(pessoa.idade)  // 28
print(pessoa.cidade) // São Paulo
}

// MARK: Array

let jsonArrayData = """
[
{
"nome": "João",
"idade": 28,
"cidade": "São Paulo"
},
{
"nome": "Maria",
"idade": 34,
"cidade": "Rio de Janeiro"
}
]
""".data(using: .utf8)!

if let pessoas = try? JSONDecoder().decode([Pessoa].self, from: jsonArrayData) {
   for pessoa in pessoas {
       print("\(pessoa.nome) - \(pessoa.cidade)")
   }
}

// MARK: Coding Keys: atributos no JSON com nomes diferentes das propriedades

struct User: Codable {
    var nome: String
    var idade: Int
    var cidade: String
    
    enum CodingKeys: String, CodingKey {
        case nome = "first_name"
        case idade = "age"
        case cidade = "city_of_residence"
    }
}
