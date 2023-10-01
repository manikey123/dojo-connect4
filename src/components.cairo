use debug::PrintTrait;
use array::Array;
use array::SpanTrait;
use starknet::ContractAddress;

// #[derive(Serde, Drop, Copy, PartialEq)]
#[derive(Drop, SerdeLen, Serde, PartialEq, Copy)]
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
    col1: Array<Slot>,
    col2: Array<Slot>,
    col3: Array<Slot>,
    col4: Array<Slot>,
    col5: Array<Slot>,
    col6: Array<Slot>,
    col7: Array<Slot>
}


impl WinnerSlotSerdeLen of dojo::SerdeLen<Option<Slot>> {
    #[inline(always)]
    fn len() -> usize {
        2
    }
}

impl ColumnSerdeLen of dojo::SerdeLen<Array<Slot>> {
    #[inline(always)]
    fn len() -> usize {
        32
    }
}

// impl GameOptionArraySlotStorageSize of dojo::SerdeLen<Array<Span<Slot>>> {
//     #[inline(always)]
//     fn len() -> usize {
//         42
//     }
// }
// #[inline(always)]
// fn packed_size() -> usize {
// 256
// }
// 

// impl GameOptionArraySlotStorageSize of dojo::StorageSize<Array<Span<Slot>>> {
// #[inline(always)]
// fn unpacked_size() -> usize {
// 42
// }

// #[inline(always)]
// fn packed_size() -> usize {
// 16384
// }
// }

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


// impl SlotEqualEmptyTrait of PartialEq<Slot> {
//     #[inline(always)]
//     fn eq(lhs:@Slot , rhs:@Slot ) {
//         return True;
//     }
//     fn ne(lhs , rhs ) {
//         return False;
//     }
//     // fn eq(self: Slot) {
//     //     match self {
//     //         Slot::Empty(_) => {
//     //             'Empty'.print();
//     //         },
//     //         Slot::Blue(_) => {
//     //             'Blue'.print();
//     //         },
//     //         Slot::Red(_) => {
//     //             'Red'.print();
//     //         },
//     //     }
//     // }
// }

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

impl ColumnPrintTrait of PrintTrait<Array<Slot>> {
    fn print(self: Array<Slot>) {
        let x: Array<Slot> = self;

        let mut row = 0;
        loop {
            if row == connect4::constants::ROWS {
                break ();
            }
            let slot = x.at(row);
            SlotPrintTrait::print(*slot);
            ' '.print();
        
            row += 1;
        }
    }
}

// impl BoardPrintTrait of PrintTrait<Array<Span<Slot>>> {
//    // #[inline(always)]
//     fn print(self: Array<Span<Slot>>) {
//         let x: Array<Span<Slot>> = self;
//         let mut row = 0;
//         let mut col = 0;

//         loop {
//             if row == connect4::constants::ROWS {
//                 break ();
//             }
//             col = 0;

//             let mut rowArr = x.at(row);

//             loop {
//                 if col == connect4::constants::COLS {
//                     break ();
//                 }

//                 'Empty'.print();
//                 //rowArr.at(col).print();
//                 col += 1;
//             };
//             row += 1;
//         };
//     }
// }
