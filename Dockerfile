FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

ENV FUZZER=/fuzzer

# Install system packages
RUN apt-get update && \
    apt-get install -y \
    make \
    build-essential \
    lsb-release \
    wget \
    software-properties-common \
    gnupg \
    tar \
    git \
    curl \
    vim

# Install LLVM 19
RUN wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh 19 && \
    rm llvm.sh

# Set up clang and clang++ alternatives
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-19 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-19 100

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /rustup.sh && \
    sh /rustup.sh -y && \
    rm /rustup.sh

ENV PATH="/root/.cargo/bin:${PATH}"

# Create fuzzer directory and clone repositories
RUN mkdir -p "$FUZZER"

# Fetch fuzzer repositories

# Clone path-cov repository
RUN git clone --no-checkout https://github.com/fEst1ck/path-cov.git "$FUZZER/path-cov" && \
    git -C "$FUZZER/path-cov" checkout 9d8fc8c73d86e63bbec64cdb3cef5608719a88a8

# Clone path-cov-instr repository
RUN git clone --no-checkout https://github.com/fEst1ck/path-cov-instr.git "$FUZZER/path-cov-instr" && \
    git -C "$FUZZER/path-cov-instr" checkout 3928dd53557abc6fd48d76ce4882c369849c9b45

# Clone coverage-playground repository
RUN git clone --no-checkout https://github.com/fEst1ck/coverage-playground.git "$FUZZER/repo" && \
    git -C "$FUZZER/repo" checkout 5455339b1a428369e7313d7a5ec83a137f1cc711

# Clone fuzz-target repository
RUN git clone https://github.com/fEst1ck/fuzz-target.git "$FUZZER/fuzz-target"

# Build path-cov-instr
RUN cd "$FUZZER/path-cov-instr" && \
    make && \
    cp libCodeCoveragePass.so $FUZZER/libCodeCoveragePass.so && \
    cp coverage_runtime.o $FUZZER/coverage_runtime.o && \
    cp path-clang $FUZZER/path-clang && \
    cp path-clang++ $FUZZER/path-clang++

# Build Rust project
RUN cd "$FUZZER/repo" && \
    rm -f Cargo.lock && \
    cargo build --release && \
    cp target/release/dummy-fuzzer $FUZZER/dummy-fuzzer

# Build fuzz target
RUN cd "$FUZZER/fuzz-target" && \
    clang -O2 -c FuzzTarget.c && \
    ar rc $FUZZER/libStandaloneFuzzTarget.a FuzzTarget.o

# Run example script
COPY example.sh /example.sh
RUN chmod +x /example.sh && \
    /example.sh

