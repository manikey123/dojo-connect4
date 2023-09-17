#[system]
mod initiate_system {
    use dojo::world::Context;
    use traits::Into;
    use starknet::ContractAddress;
    use connect4::components::{Slot, Game};

    fn execute(
        ctx: Context,
        game_id: felt252,
        blue_id: ContractAddress,
        red_id: ContractAddress
    ) {
        // Initialize_game with a grid of r x c: 6 x 7 for a classic game
        let mut board = array::ArrayTrait::<Span<Slot>>::new();
        let mut row = 0;
        let mut col = 0;

        loop {
            if row == connect4::constants::ROWS {
                break ();
            }

            col = 0;
            let mut boardRow = ArrayTrait::<Slot>::new();

            loop {
                if col == connect4::constants::COLS {
                    break ();
                }
                boardRow.append(Slot::Empty);
                col += 1;
            };

            board.append(boardRow.span());
            row += 1;
        };

        set !(
            ctx.world,
            (
                Game {
                    game_id : game_id.into(),
                    winner: Option::None(()), 
                    blue:  blue_id,
                    red: red_id,
                    board: board
                }
            )
        )        
    }
}

#[cfg(test)]
mod tests {
    use starknet::ContractAddress;
    use dojo::test_utils::spawn_test_world;
    use connect4::components::{Game, game};
    use connect4::systems::initiate_system;
    use array::ArrayTrait;
    use core::traits::Into;
    use dojo::world::IWorldDispatcherTrait;
    use core::array::SpanTrait;
   // use dojo::StorageSize

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
        calldata.append('gameid'.into());
        calldata.append(blue.into());
        calldata.append(red.into());

        world.execute('initiate_system'.into(), calldata);

        let game = world
            .entity('Game'.into(), 'gameid'.into(), 0_u8, dojo::StorageSize::<Game>::packed_size());

        assert(game::board::len() == 6, 'board rows not correct');
    }
}