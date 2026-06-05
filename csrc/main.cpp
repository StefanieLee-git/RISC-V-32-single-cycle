#include "verilated.h"
#include "verilated_fst_c.h"
#include "Vtop.h"

VerilatedContext* contextp = NULL;
VerilatedFstC* tfp = NULL;

static Vtop* top;

void step_and_dump_wave()
{
	if (!tfp || !tfp->isOpen()) 
	{  
    fprintf(stderr, "FST not open at t=%" PRIu64 "\n", contextp->time());
    abort();
  }

	top->clk = 0; top->eval();
  tfp->dump(contextp->time());
	contextp->timeInc(1);

	top->clk = 1; top->eval();
	tfp->dump(contextp->time());
	contextp->timeInc(1);
}

void sim_init()
{
  contextp = new VerilatedContext;
  tfp = new VerilatedFstC;
  top = new Vtop;
  contextp->traceEverOn(true);
  top->trace(tfp, 0);
  tfp->open("logs/top.fst");
}

void reset(int cycles)
{
	if (!top) return;

	top->reset = 1;
	for (int i = 0; i < cycles; i++)
	{
		step_and_dump_wave();
	}
	top->reset = 0;
	step_and_dump_wave();
}

void sim_exit()
{
  step_and_dump_wave();
	puts("sim_exit() reached");
  tfp->close();

	delete top;
	delete tfp;
	delete contextp;

	top = NULL;
	tfp = NULL;
	contextp = NULL;
}

int main()
{
		char cwd[32];
if (getcwd(cwd, sizeof(cwd)) != NULL) {
    printf("Current working dir: %s\n", cwd);
} else {
    perror("getcwd() error");
}	

    puts("start sim_init");
    sim_init();
    puts("sim_init done, entering main loop");
		
		reset(5);
		
		int i = 7000;
		while (i)
		{
			step_and_dump_wave();
			i--;
		}


    puts("TOP test completed");
    sim_exit();
    return 0;
}
