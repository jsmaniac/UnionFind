(* Naive persistent implementation of Union/Find: O(n^2) worst case *)

module Make (Item: Partition.Item) =
  struct

    type item = Item.t

    let equal i j = Item.compare i j = 0

    module ItemMap = Map.Make (Item)

    type height = int

    type partition = item ItemMap.t
    type t = partition

    let empty = ItemMap.empty

    let rec repr item partition : item =
      let parent = ItemMap.find item partition in
      if   equal parent item
      then item
      else repr parent partition

    let is_equiv (i: item) (j: item) (p: partition) : bool =
      try equal (repr i p) (repr j p) with
        Not_found -> false

    let get_or_set (i: item) (p: partition) : item * partition =
      try repr i p, p with Not_found -> i, ItemMap.add i i p

    let repr item partition =
      try Some (repr item partition) with Not_found -> None

    let equiv (i: item) (j: item) (p: partition) : partition =
      let ri, p = get_or_set i p in
      let rj, p = get_or_set j p in
      if equal ri rj then p else ItemMap.add ri rj p

    let alias = equiv

   (* Printing *)

    let print (p: partition) =
      let buffer = Buffer.create 80 in
      let print src dst =
        let link =
          Printf.sprintf "%s -> %s\n"
                         (Item.to_string src) (Item.to_string dst)
        in Buffer.add_string buffer link
      in ItemMap.iter print p; buffer

  end
