require 'spec_helper'

describe AppointmentQueue::Base do
  before(:each) do
    @queue = AppointmentQueue::Base.new('__test')
    @queue.clear!
  end

  after(:each) do
    @queue.clear!
  end

  context 'initiliaze' do
    it 'should create a new redis-queue object' do
      queue = AppointmentQueue::Base.new('__test1')

      expect(queue.class).to eq(AppointmentQueue::Base)
    end
  end

  context 'public method' do
    context 'call its method' do
      it { expect(@queue).to respond_to(:push) }
      it { expect(@queue).to respond_to(:will_pop_element) }
      it { expect(@queue).to respond_to(:queue_before_me).with(1) }
      it { expect(@queue).to respond_to(:top_element) }
      it { expect(@queue).to respond_to(:pop) }
      it { expect(@queue).to respond_to(:remove).with(1) }
      it { expect(@queue).to respond_to(:size) }
      it { expect(@queue).to respond_to(:clear!) }
      it { expect(@queue).to respond_to(:members) }
    end

    context 'excute success' do
      context '#push' do
        it 'should push an element to the queue' do
          queue = @queue.push('a')

          expect(queue).to eq(true)
          expect(@queue.size).to eq(1)
        end
      end

      context '#will_pop_element' do
        it 'should return nil when no element can pop' do
          element = @queue.will_pop_element

          expect(element).to eq(nil)
        end

        it 'return the element can pop' do
          @queue.push('a')
          @queue.push('b')
          @queue.push('c')

          element = @queue.will_pop_element

          expect(element).to eq('a')
        end
      end

      context '#queue_before_me' do
        it 'should return 0 if have not find the element' do
          element = @queue.queue_before_me('a')

          expect(element).to eq(0)
        end

        it 'should return the index if have find the element' do
          @queue.push 'a' #0
          @queue.push 'b' #1
          element1 = @queue.queue_before_me('a')
          element2 = @queue.queue_before_me('b')

          expect(element1).to eq(0)
          expect(element2).to eq(1)
        end
      end

      context '#top_element' do
        it 'should return nil when no top element' do
          element = @queue.top_element

          expect(element).to eq(nil)
        end

        it 'should return last push element' do
          @queue.push('a')
          @queue.push('b')

          element = @queue.top_element

          expect(element).to eq('b')
        end
      end

      context '#pop' do
        it 'should return an element from the queue' do
          @queue.push 'b'
          @queue.push 'c'

          results = @queue.pop

          expect(results).to eq('b')
        end

        it 'no element to pop will retrun nil' do
          results = @queue.pop

          expect(results).to eq(nil)
        end
      end

      context '#remove' do
        it 'no mactch element can remove will return false' do
          @queue.push('a')
          @queue.push('b')
          @queue.push('c')

          results = @queue.remove('d')

          expect(results).to eq(false)
          expect(@queue.size).to eq(3)
        end

        it 'remove element success' do
          @queue.push('a')
          @queue.push('b')
          @queue.push('c')

          results = @queue.remove('a')

          expect(results).to eq(true)
          expect(@queue.size).to eq(2)
        end
      end

      context '#size' do
        it 'caculate the size of queue' do
          @queue.push('a')

          results = @queue.size
          expect(results).to eq(1)
        end
      end

      context '#clear!' do
        it 'expect clear return true' do
          @queue.push('a')
          @queue.push('b')
          @queue.push('c')

          results = @queue.clear!
          expect(results).to eq(1)
          expect(@queue.size).to eq(0)
        end
      end

      context '#members' do
        it 'expect the members to' do
          @queue.push('a')
          @queue.push('b')
          @queue.push('c')

          results = @queue.members
          expect(results).to eq(['a', 'b', 'c'])
        end

        it 'empty will return empty arrary' do
          results = @queue.members
          expect(results).to eq([])
        end
      end
    end
  end
end