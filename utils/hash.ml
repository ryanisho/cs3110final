type t = Sha256.t

let hash (filename : string) : t = Sha256.string ""
