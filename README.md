# GORAM: Graph-oriented ORAM for Efficient Ego-centric Queries on Federated Graphs

## Aritifact Structure

We implement GORAM and the benchmark queries on top of the well-known ABY3 project. The structure of the aritifact is as follows:

```
.
|-- GORAM_Eval // Evaluation scripts.
|   |-- build.sh // Script to build the project.
|   |-- micro_benchmark_init.sh
|   |-- micro_benchmark_query.sh
|   |-- real_world.sh
|   `-- unit_test.sh
|-- README.md
`-- aby3 // ABY3 framework with GORAM extensions.
    |-- CMakeLists.txt
    |-- Eval
    |-- GORAM // GORAM evaluation scripts.
    |-- LICENSE
    |-- README.md
    |-- aby3
    |-- aby3-GORAM // GORAM structure and benchmark queries.
    |-- aby3-GORAM-Core // Core implementations of GORAM.
    |-- aby3_tests
    `-- .. (Other aby3 origional implementations)
```

The GORAM extensions on ABY3 includes:

```
|-- CMakeLists.txt
|-- Graph.h // // GORAM and other baseline structures (Section3&4). 
|-- GraphQuery.cpp // Graph queries (Section6).
|-- benchmark.cpp
|-- benchmark.h // Graph query benchmarks (Section8)
|-- pGraph.h // Graph structure (Section4).
|-- plaintext.cpp
|-- privGraphQuery // Data preprocessing and organizations.
`-- ...
```

```
./aby3/aby3-GORAM-Core/
|-- ArithBasic.cpp
|-- Basic.cpp
|-- Basics.h // Basic building blocks (Section2).
|-- BoolBasic.cpp
|-- CMakeLists.txt
|-- Oram
|   |-- include
|   `-- src
|-- Shuffle.cpp
|-- Shuffle.h // Optimized shuffle initialization (Section5).
|-- Sort.cpp
|-- Sort.h // Sort implementations (Section4).
|-- SqrtOram.cpp
|-- SqrtOram.h // Square-root ORAM (Section2).
|-- assert.h
`-- timer.h
```


## 0. Preparation

### 0.1 Build the project (TL;DR)

For a quick and convenient project build, simply use the following command:

```
./GORAM_Eval/build.sh
```

## 1. GORAM Evaluations

For ease of testing, all the provided shell scripts initiate three computational parties in three separate processes. It's straightforward to extend this to multiple servers. The corresponding commands are provided in the comments of ``./aby3/Eval/dis_exec.sh``.

### 1.1 Unit test
We have provided unit tests for GORAM's core components and graph queries in ``./aby3/aby3_tests/``. You can execute all the unit tests using the following command:


```
./GORAM_Eval/unit_test.sh
```

This command will prepare the test data, build the project, and run the unit tests. The expected output is:


<pre><code>RUN SHUFFLE TEST

<span style="color: green;">SHUFFLE CHECK SUCCESS ! </span>

<span style="color: green;">SHUFFLE in shuffle and permutation CHECK SUCCESS ! </span>

<span style="color: green;">PERMUTATION in shuffle and permutation CHECK SUCCESS ! </span>

RUN PERMUTATION NETWORK TEST
<span style="color: green;">RANDOM SWITCH CHECK SUCCESS ! </span>

<span style="color: green;">PERMUTATION NETWORK CHECK SUCCESS ! </span>

RUN SQRT-ORAM Position Map TEST
and other tests ...
</code></pre>


### 1.2 Micro-benchmarks

To run the corresponding micro-benchmark evaluations, use the following commands:

```
./GORAM_Eval/micro_benchmark_query.sh
```

and 

```
./GORAM_Eval/micro_benchmark_init.sh
```

We only provide the small scale graphs for demonstration. You can add the testing scales in:

```
./aby3/GORAM/graph_format_benchmark.py
```

The evaluation results will be collected in ``./aby3/GORAM/results/`` and ``./aby3/GORAM/results_offline/``


### 1.3 Real-world tests

To run the real-world evaluations, use the following command:

```
./GORAM_Eval/real_world.sh
```

The evaluation results will be gathered in ``./aby3/GORAM/results_real_world/``

