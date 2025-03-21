import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";

actor Defreelance {
    type Job = {
        id: Text;
        title: Text;
        description: Text;
        employer: Principal;
        assignedTo: ?Principal;
        isCompleted: Bool;
    };

    stable var jobCounter : Nat = 0;
    var jobs = HashMap.HashMap<Text, Job>(10, Text.equal, Text.hash);

    public func createJob(title: Text, description: Text) : async Text {
        let jobId = "job_" # Nat.toText(jobCounter);
        let newJob : Job = {
            id = jobId;
            title = title;
            description = description;
            employer = Principal.fromActor(Defreelance);
            assignedTo = null;
            isCompleted = false;
        };
        jobs.put(jobId, newJob);
        jobCounter += 1;
        return jobId;
    };

    public query func getJobs() : async [Job] {
      Iter.toArray(jobs.vals());
    };

    public func assignJob(jobId: Text, freelancer: Principal) : async Bool {
        switch (jobs.get(jobId)) {
            case (?job) {
                let updatedJob = { job with assignedTo = ?freelancer };
                jobs.put(jobId, updatedJob);
                return true;
            };
            case (_) return false;
        }
    };

    public func completeJob(jobId: Text) : async Bool {
        switch (jobs.get(jobId)) {
            case (?job) {
                let updatedJob = { job with isCompleted = true };
                jobs.put(jobId, updatedJob);
                return true;
            };
            case (_) return false;
        }
    };
};
