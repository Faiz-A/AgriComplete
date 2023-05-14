
def lcg(seed, a, c, m, n):
    x = seed
    for i in range(n):
        x = (a * x + c) % m
        yield x

a = 11
c = 123
m = 10
n = 6

IAT = list(lcg(0, a, c, m, n))
ST = list(lcg(1, a, c, m, n))
event_list = [(0.0, "arrival")]
clock = 0.0
LQ = 0
LS = 0
max_queue_len = 0
idle_time = 0.0
max_busy_time = 0.0
curr_busy_time = 0.0
queue = []
simulation_time = sum(IAT) + max(ST)

print("{:<10} {:<10} {:<10} {:<10} {:<40} {:<20}".format("Clock", "LQ(t)", "LS(t)", "Max LQ(t)", "Future Event List", "Event DetaiLS"))
print("-" * 100)
import heapq
next_AT = clock
while event_list and clock < simulation_time:
    event_time, event_type = heapq.heappop(event_list)
    if LS == 1:
        curr_busy_time += (event_time - clock)
        max_busy_time = max(max_busy_time, curr_busy_time)
    else:
        idle_time += (event_time - clock)
        curr_busy_time = 0.0
    clock = event_time
    if event_type == "arrival":
        if IAT:
            next_AT += IAT.pop(0)
            if next_AT <= simulation_time:
                heapq.heappush(event_list, (next_AT, "arrival"))
        if LS == 0:
            LS = 1
            if ST:
                departure_time = clock + ST[0]
                heapq.heappush(event_list, (departure_time, "departure"))
        eLSe:
            LQ += 1
            queue.append((clock, ST.pop(0)))
            max_queue_len = max(max_queue_len, LQ)
    elif event_type == "departure":
        LS = 0
        if queue:
            LQ -= 1
            arrival_time, service_time = queue.pop(0)
            LS = 1
            departure_time = clock + service_time
            heapq.heappush(event_list, (departure_time, "departure"))
    future_event_list = []
    if IAT:
        future_event_list.append(("arrival", next_AT))
    if LS == 0 and queue:
        future_event_list.append(("arrival", queue[0][0]))
    if LS == 1:
        departure_time = clock + ST[0]
        future_event_list.append(("departure", departure_time))
    if LQ:
        max_queue_len = max(max_queue_len, LQ)
    print("{:<10} {:<10} {:<10} {:<10} {:<40} {:<20}".format(clock, LQ, LS, max_queue_len, str(future_event_list),
                                                             "{} at {}".format(event_type, event_time)))


if LS == 0:

    idle_time += simulation_time - clock
eLSe:

    busy_time = simulation_time - idle_time
    busy_time += (ST[0] - (departure_time - clock))


avg_LQ = sum(queue_time[0] for queue_time in queue) / simulation_time
avg_LS = sum(service_time for service_time in ST) / simulation_time
avg_idle_time = idle_time / simulation_time
avg_busy_time = busy_time / simulation_time

print("-" * 90)
