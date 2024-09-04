// MARK: Hashable

// MARK: Oque é Hash?

/// O valor de hash é uma representação numérica única de um objeto. Esse valor numérico é usada em várias estruturas de dados como Set e Dictionary para armazenar e buscar elementos de forma eficiente.

// MARK: Como conformar com o protocolo Hashable?

/// Em Swift, conformar-se ao protocolo Hashable geralmente é tão fácil quanto adicionar Hashable à sua lista de conformidade (depois dos ":").  No entanto, se você tiver requisitos personalizados ou usar propriedades que não conformem ao Hashable, isso exigirá um pouco mais de trabalho.

/// Aqui está um exemplo de struct com o qual podemos trabalhar:

    struct Mac: Hashable {
        let serialNumber: String
        let capacity: Int
        let ramMemory: Int
        var macOSVersion: Float
    }

/// Como essa struct conforma-se ao protocolo Hashable e ambas as suas propriedades também conformam-se ao protocolo Hashable, o Swift gerará automaticamente um método hash(into:) que é utilizado para calcular o hash de uma instância de uma estrutura ou classe que conforma ao protocolo Hashable.

/// Então quando você adicionar uma instância de Mac à um Set ou a um Dicionario o próprio swift vai usar internamente o metodo hash(into: ) para calcular  o valor de hash dessa instância.

/// Exemplo:

    var MacsSet: Set<Mac> = []

    let Mac1 = Mac(serialNumber: "A1234", capacity: 64, ramMemory: 16, macOSVersion: 17.4)
    let Mac2 = Mac(serialNumber: "B5678", capacity: 128, ramMemory: 32, macOSVersion: 17.2)

    MacsSet.insert(Mac1)
    MacsSet.insert(Mac2)

/// Ou com dicionários
    
    var MacsDictionary: Dictionary<Mac, String> = [:]

    let Mac3 = Mac(serialNumber: "C1234", capacity: 32, ramMemory: 16, macOSVersion: 17.4)
    let Mac4 = Mac(serialNumber: "D5678", capacity: 64, ramMemory: 32, macOSVersion: 15.1)

    let owner1 = "Junin"
    let owner2 = "Mariazinha"

    MacsDictionary[Mac3] = owner1
    MacsDictionary[Mac4] = owner2

// MARK: O que Acontece nos Bastidores:

/// 1.    Cálculo do Hash: Quando você insere Mac1 no Set, o método hash(into:) é chamado para calcular um valor de hash único baseado no serialNumber, na capacity , ramMemory e na macOSVersion. Este valor de hash determina onde o objeto é armazenado no Set.

/// 2.    Busca por Duplicatas: Se você tentar adicionar outro Mac com o mesmo serialNumber e capacity, ramMemory e macOSVersiono Swift calculará o hash novamente e o comparará com os hashes existentes no Set para verificar se o item já está presente. Se o hash e as propriedades principais (==) forem iguais, o novo objeto não será adicionado, porque Set não permite duplicatas.

/// 3.    Dicionários: Da mesma forma, quando você usa uma instância de Mac como chave em um Dictionary, o Swift usa o valor de hash para determinar onde armazenar a chave-valor e para recuperar valores rapidamente.

// MARK: E se eu quiser customizar o metodo hash(into: )

/// Se você quiser que o hash seja calculado de uma forma específica (por exemplo, apenas com base no serialNumber e na capacity), você pode personalizar o método hash(into:):

struct Macintosh: Hashable {
    let serialNumber: String
    let capacity: Int
    let ramMemory: Int
    var macOSVersion: Float
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(serialNumber)
        hasher.combine(capacity)
    }
}

