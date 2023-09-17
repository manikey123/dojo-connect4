use debug::PrintTrait;
use array::Array;
use array::SpanTrait;
use starknet::ContractAddress;


#[derive(Serde, Drop, Copy, PartialEq)]
enum Slot {
    Empty,
    Blue,
    Red,
}

#[derive(Component, Drop, SerdeLen, Serde)]
struct Game {
    #[key]
    game_id: felt252,
    winner: Option<Slot>,
    blue: ContractAddress,
    red: ContractAddress,
    board: Array<Span<Slot>>,
}


impl GameOptionSlotStorageSize of dojo::StorageSize<Option<Slot>> {
    #[inline(always)]
    fn unpacked_size() -> usize {
        1
    }

    #[inline(always)]
    fn packed_size() -> usize {
        256
    }
}

impl GameOptionArraySlotStorageSize of dojo::StorageSize<Array<Span<Slot>>> {
    #[inline(always)]
    fn unpacked_size() -> usize {
        42
    }

    #[inline(always)]
    fn packed_size() -> usize {
        16384
    }
}

//printing trait for debug

impl SlotPrintTrait of PrintTrait<Slot> {
    #[inline(always)]
    fn print(self: Slot) {
        match self {
            Slot::Empty(_) => {
                'Empty'.print();
            },
            Slot::Blue(_) => {
                'Blue'.print();
            },
            Slot::Red(_) => {
                'Red'.print();
            },
        }
    }
}

impl SlotOptionPrintTrait of PrintTrait<Option<Slot>> {
    #[inline(always)]
        fn print(self: Option<Slot>) {
        match self {
            Option::Some(slot_type) => {
                slot_type.print();
            },
            Option::None(_) => {
                'None'.print();
            }
        }
    }
}

impl BoardPrintTrait of PrintTrait<Array<Span<Slot>>> {
   // #[inline(always)]
    fn print(self: Array<Span<Slot>>) {
        let x: Array<Span<Slot>> = self;
        let mut row = 0;
        let mut col = 0;

        loop {
            if row == connect4::constants::ROWS {
                break ();
            }
            col = 0;

            let mut rowArr = x.at(row);

            loop {
                if col == connect4::constants::COLS {
                    break ();
                }

                'Empty'.print();
                //rowArr.at(col).print();
                col += 1;
            };
            row += 1;
        };
    }
}
