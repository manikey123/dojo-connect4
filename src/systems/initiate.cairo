#[system]
mod initiate_system {
    use dojo::world::Context;
    use traits::Into;
    use connect4::components::ColumnPrintTrait;
    use starknet::ContractAddress;
    use connect4::components::{Slot, Game};

    fn execute(
        ctx: Context,
        blue_id: ContractAddress,
        red_id: ContractAddress
    ) {
                let game_id = pedersen::pedersen(blue_id.into(), red_id.into());

        // Initialize_game with a grid of r x c: 6 x 7 for a classic game
        let mut col1 = array::ArrayTrait::<Slot>::new();
        let mut col2 = array::ArrayTrait::<Slot>::new();
        let mut col3 = array::ArrayTrait::<Slot>::new();
        let mut col4 = array::ArrayTrait::<Slot>::new();
        let mut col5 = array::ArrayTrait::<Slot>::new();
        let mut col6 = array::ArrayTrait::<Slot>::new();
        let mut col7 = array::ArrayTrait::<Slot>::new();

        let mut row = 0;

        loop {
            if row == connect4::constants::ROWS {
                break ();
            }

            col1.append(Slot::Empty);
            col2.append(Slot::Empty);
            col3.append(Slot::Empty);
            col4.append(Slot::Empty);
            col5.append(Slot::Empty);
            col6.append(Slot::Empty);
            col7.append(Slot::Empty);
            row += 1;
        };

        'Got Here!'.print();
        connect4::components::SlotPrintTrait::print(*col1.at(0));
        //ColumnPrintTrait::print(col1);

        set !(
            ctx.world,
            (
                Game {
                    game_id : game_id,
                    winner: Option::None, 
                    blue:  blue_id,
                    red: red_id,
                    col1: col1,
                    col2: col2,
                    col3: col3,
                    col4: col4,
                    col5: col5,
                    col6: col6,
                    col7: col7
                }
            )
        );

        'Got Here 2'.print();        
    }
}

#[cfg(test)]
mod tests {
    use starknet::ContractAddress;
    use dojo::test_utils::spawn_test_world;
    use connect4::components::{Game, game, Slot};
    use connect4::systems::initiate_system;
    use array::ArrayTrait;
    use core::traits::Into;
    use dojo::world::IWorldDispatcherTrait;
    use core::array::SpanTrait;
    use debug::PrintTrait;
    use connect4::components::SlotPartialEq;

    #[test]
    #[available_gas(3000000000000000)]
    fn init() {
        let blue = starknet::contract_address_const::<0x01>();
        let red = starknet::contract_address_const::<0x02>();

        // Components
        let mut components = array::ArrayTrait::new();
        components.append(game::TEST_CLASS_HASH);

        // Systems
        let mut systems = array::ArrayTrait::new();
        systems.append(initiate_system::TEST_CLASS_HASH);

        let world = spawn_test_world(components, systems);

        let mut calldata = array::ArrayTrait::<core::felt252>::new();
        calldata.append(blue.into());
        calldata.append(red.into());

        world.execute('initiate_system'.into(), calldata);

        'Test got here'.print();
        let game_id = pedersen::pedersen(blue.into(), red.into());

        let game = get!(world, (game_id), (Game));

        'Test got here 2'.print();
        assert(game.blue == blue, 'blue address is incorrect');
        assert(game.red == red, 'red address is incorrect');
        assert(game.col1.len() == 6, 'col1 is not correct' );
       let mut row = 0;
       let EmptySlot = connect4::components::Slot::Empty;
       



        loop {
            if row == connect4::constants::ROWS {
                break ();
            }

            assert(SlotPartialEq::eq(game.col1.at(row), @EmptySlot), 'Slot is not Empty');
            assert(SlotPartialEq::eq(game.col2.at(row), @EmptySlot), 'Slot is not Empty');
            assert(SlotPartialEq::eq(game.col3.at(row), @EmptySlot), 'Slot is not Empty');
            assert(SlotPartialEq::eq(game.col4.at(row), @EmptySlot), 'Slot is not Empty');
            assert(SlotPartialEq::eq(game.col5.at(row), @EmptySlot), 'Slot is not Empty');
            assert(SlotPartialEq::eq(game.col6.at(row), @EmptySlot), 'Slot is not Empty');
            assert(SlotPartialEq::eq(game.col7.at(row), @EmptySlot), 'Slot is not Empty');

            row += 1;
        };

    }
}