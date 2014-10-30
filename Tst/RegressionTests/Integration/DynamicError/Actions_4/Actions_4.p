// This sample tests overriding of action handlers by a pushed state
event E1 assert 1;
event E2 assert 1;
event E3 assert 1;
event E4 assert 1;
event unit assert 1;

main machine Real {
    var ghost_machine: model;
    var test: bool;
    start state Real_Init {
        entry {
			ghost_machine = new Ghost(this);  
			raise unit;	   
        }
        on unit do Action1;
        on E4 goto Real_S2;
        exit {
			test = true;
        }
    }

    state Real_S1 {
    on unit do Action2;  // overrides Action1 on unit installed by Real_Init
	entry {
        send ghost_machine, E1;
	    raise unit;
	}
    }

    state Real_S2 {
	entry {
		//this assert is reachable:
        assert(test == false);
	}
    }

    fun Action1() {
        push Real_S1; 
        send ghost_machine, E3;
    }
 
    fun Action2() {
		pop;
    }
}

model Ghost {
    var real_machine: machine;
    start state Ghost_Init {
        entry {
	      real_machine = payload as machine;
        }
        on E1 goto Ghost_S1;
    }

    state Ghost_S1 {
        entry {
        }
        on E3 goto Ghost_S2;
    }

    state Ghost_S2 {
        entry {
	    send real_machine, E4;
        }
    }
}